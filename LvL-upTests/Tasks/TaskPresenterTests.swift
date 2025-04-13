//
//  TaskPresenterTests.swift
//  LvL-upTests
//
//  Created by MyBook on 13.04.2025.
//

import XCTest
import Combine
@testable import LvL_up

class TaskPresenterTests: XCTestCase {
    
    var presenter: TaskPresenter!
    var mockInteractor: MockTaskInteractor!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
        mockInteractor = MockTaskInteractor()
        presenter = TaskPresenter(interactor: mockInteractor)
    }
    
    override func tearDown() {
        presenter = nil
        mockInteractor = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - getData Tests
    
    func testGetDataUpdatesTaskArrays() async {
        // Given
        let testTasks = DailyTask.mockTasks
        mockInteractor.stubbedLoadTasksResult = testTasks
        
        // When
        await presenter.getData()
        
        // Then
        XCTAssertEqual(presenter.completedTask.count, 1)
        XCTAssertEqual(presenter.notCompletedTask.count, 4)
        XCTAssertEqual(presenter.completedTask.first?.title, "Спать 8 часов")
    }
    
    // MARK: - updateCurrentProgress Tests
    
    func testUpdateCurrentProgressWithValidCheckPoint() {
        // Given
        let initialTask = DailyTask.mockTasks[0] // Не завершена
        presenter.notCompletedTask = [initialTask]
        
        // When
        presenter.updateCurrentProgress(to: initialTask, checkPoint: 3)
        
        // Then
        XCTAssertEqual(mockInteractor.updatedTask?.checkPoint, 3)
        XCTAssertEqual(presenter.updateCurrentLvlEx, initialTask.calculateRewardForCheckPoint())
    }
    
    func testUpdateCurrentProgressWithInvalidCheckPoint() {
        // Given
        let initialTask = DailyTask.mockTasks[0]
        presenter.notCompletedTask = [initialTask]
        
        // When
        presenter.updateCurrentProgress(to: initialTask, checkPoint: -1) // Невалидный
        presenter.updateCurrentProgress(to: initialTask, checkPoint: 100) // Невалидный
        
        // Then
        XCTAssertNil(mockInteractor.updatedTask) // Не должно обновляться
    }
    
    func testUpdateCurrentProgressCompletesTask() {
        // Given
        let initialTask = DailyTask.mockTasks[0] // checkPoints = 5
        presenter.notCompletedTask = [initialTask]
        
        // When
        presenter.updateCurrentProgress(to: initialTask, checkPoint: 5) // Завершаем
        
        // Then
        XCTAssertEqual(presenter.completedTask.count, 1)
        XCTAssertTrue(presenter.completedTask.first?.isCompleted ?? false)
        XCTAssertEqual(presenter.notCompletedTask.count, 0)
    }
    
    func testUpdateCurrentProgressRevertsCompletion() {
        // Given
        let completedTask = DailyTask.mockTasks[2] // Уже завершена
        presenter.completedTask = [completedTask]
        
        // When
        presenter.updateCurrentProgress(to: completedTask, checkPoint: 0) // Возвращаем
        
        // Then
        XCTAssertEqual(presenter.notCompletedTask.count, 1)
        XCTAssertFalse(presenter.notCompletedTask.first?.isCompleted ?? true)
        XCTAssertEqual(presenter.completedTask.count, 0)
    }
    
    // MARK: - updateMainLvl Tests (via observation)
    
    func testUpdateMainLvlIncreasesExp() {
        // Given
        let task = DailyTask.mockTasks[0]
        let expectation = XCTestExpectation(description: "Exp updated")
        
        presenter.$updateCurrentLvlEx
            .dropFirst()
            .sink { newValue in
                XCTAssertEqual(newValue, task.calculateRewardForCheckPoint())
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        presenter.updateCurrentProgress(to: task, checkPoint: 1)
        
        // Then
        wait(for: [expectation], timeout: 1)
    }
    
    func testUpdateMainLvlDecreasesExp() {
        // Given
        let task = DailyTask.mockTasks[0]
        task.updateCurrentProgress(3) // Сначала прогресс 3
        presenter.notCompletedTask = [task]
        let expectation = XCTestExpectation(description: "Exp updated")
        
        presenter.$updateCurrentLvlEx
            .dropFirst()
            .sink { newValue in
                XCTAssertEqual(newValue, task.calculateRewardForCheckPoint())
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        presenter.updateCurrentProgress(to: task, checkPoint: 2) // Уменьшаем
        
        // Then
        wait(for: [expectation], timeout: 1)
    }
    
    // MARK: - updateArraysLogic Tests
    
    func testUpdateArraysLogicCompleteTask() {
        // Given
        let task = DailyTask.mockTasks[0]
        presenter.notCompletedTask = [task]
        
        // When
        let completedTask = task.updateCurrentProgress(task.checkPoints) // Завершаем
        presenter.updateArraysLogic(task: completedTask, isCompleted: false)
        
        // Then
        XCTAssertEqual(presenter.completedTask.count, 1)
        XCTAssertEqual(presenter.notCompletedTask.count, 0)
    }
    
    func testUpdateArraysLogicUpdateExistingTask() {
        // Given
        let task = DailyTask.mockTasks[0]
        presenter.notCompletedTask = [task]
        
        // When
        let updatedTask = task.updateCurrentProgress(2)
        presenter.updateArraysLogic(task: updatedTask, isCompleted: false)
        
        // Then
        XCTAssertEqual(presenter.notCompletedTask.count, 1)
        XCTAssertEqual(presenter.notCompletedTask.first?.checkPoint, 2)
    }
    
    func testUpdateArraysLogicRevertCompletion() {
        // Given
        let task = DailyTask.mockTasks[2] // Завершенная
        presenter.completedTask = [task]
        
        // When
        let revertedTask = task.updateCurrentProgress(0)
        presenter.updateArraysLogic(task: revertedTask, isCompleted: true)
        
        // Then
        XCTAssertEqual(presenter.notCompletedTask.count, 1)
        XCTAssertEqual(presenter.completedTask.count, 0)
    }
}

// MARK: - Mock Task Interactor

class MockTaskInteractor: TaskInteractorProtocol {
    var stubbedLoadTasksResult: [DailyTask] = []
    var updatedTask: DailyTask?
    var createdTask: DailyTask?
    var deletedTask: DailyTask?
    
    func loadTasks() -> [DailyTask] {
        return stubbedLoadTasksResult
    }
    
    func update(_ dailyTask: DailyTask) {
        updatedTask = dailyTask
    }
    
    func create(_ dailyTask: DailyTask) {
        createdTask = dailyTask
    }
    
    func delete(_ dailyTask: DailyTask) {
        deletedTask = dailyTask
    }
}
