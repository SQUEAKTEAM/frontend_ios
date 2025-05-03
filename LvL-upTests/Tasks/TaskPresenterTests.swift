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
    
    // MARK: - Test Setup
    
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
    
    // MARK: - Test Data
    
    private var mockTasks: [DailyTask] {
        return [
            DailyTask(id: 1, img: "sleep", isCompleted: false, reward: 10, title: "Sleep 8 hours", checkPoints: 5, category: "Health"),
            DailyTask(id: 2, img: "workout", isCompleted: false, reward: 15, title: "Workout", checkPoints: 3, category: "Fitness"),
            DailyTask(id: 3, img: "read", isCompleted: true, reward: 5, title: "Read a book", checkPoints: 1, category: "Learning"),
            DailyTask(id: 4, img: "water", isCompleted: false, reward: 8, title: "Drink water", checkPoints: 4, category: "Health"),
            DailyTask(id: 5, img: "meditate", isCompleted: false, reward: 12, title: "Meditate", checkPoints: 2, category: "Mindfulness")
        ]
    }
    
    // MARK: - getData Tests
    
    func testGetDataSeparatesCompletedAndIncompleteTasks() async {
        // Given
        mockInteractor.stubbedLoadTasksResult = mockTasks
        
        // When
        await presenter.getData()
        
        // Then
        XCTAssertEqual(presenter.completedTask.count, 1, "Should have 1 completed task")
        XCTAssertEqual(presenter.notCompletedTask.count, 4, "Should have 4 incomplete tasks")
        XCTAssertEqual(presenter.completedTask.first?.title, "Read a book", "Completed task should be 'Read a book'")
    }
    
    func testGetDataCombinesDatedAndUndatedTasks() async {
        // Given
        let datedTask = DailyTask(id: 6, img: "dated", isCompleted: false, reward: 5, title: "Dated Task", checkPoints: 1, category: "Test", date: Date())
        let undatedTask = DailyTask(id: 7, img: "undated", isCompleted: false, reward: 5, title: "Undated Task", checkPoints: 1, category: "Test")
        
        mockInteractor.stubbedLoadTasksResult = [datedTask]
        mockInteractor.stubbedLoadTasksNoDateResult = [undatedTask]
        
        // When
        await presenter.getData()
        
        // Then
        XCTAssertEqual(presenter.notCompletedTask.count, 2, "Should combine both dated and undated tasks")
        XCTAssertTrue(presenter.notCompletedTask.contains(where: { $0.id == 6 }), "Should contain dated task")
        XCTAssertTrue(presenter.notCompletedTask.contains(where: { $0.id == 7 }), "Should contain undated task")
    }
    
    // MARK: - Helper Methods
    
    func testGetNoCompletedTasksFiltersCorrectly() {
        // Given
        let dailyTask = DailyTask(id: 9, img: "daily", isCompleted: false, reward: 5, title: "Daily Task", checkPoints: 1, category: "Test", date: Date())
        let nonDailyTask = DailyTask(id: 10, img: "nondaily", isCompleted: false, reward: 5, title: "Non-Daily Task", checkPoints: 1, category: "Test")
        
        presenter.notCompletedTask = [dailyTask, nonDailyTask]
        
        // When
        let dailyTasks = presenter.getNoCompletedTasks(true)
        let nonDailyTasks = presenter.getNoCompletedTasks(false)
        
        // Then
        XCTAssertEqual(dailyTasks.count, 1, "Should filter daily tasks correctly")
        XCTAssertEqual(nonDailyTasks.count, 1, "Should filter non-daily tasks correctly")
    }
}

// MARK: - Mock Task Interactor

class MockTaskInteractor: TaskInteractorProtocol {
    var stubbedLoadTasksResult: [DailyTask] = []
    var stubbedLoadTasksNoDateResult: [DailyTask] = []
    var updatedTask: DailyTask?
    var createdTask: DailyTask?
    var deletedTask: DailyTask?
    
    func loadTasks(at date: Date?) async -> [DailyTask] {
        if date != nil {
            return stubbedLoadTasksResult
        } else {
            return stubbedLoadTasksNoDateResult
        }
    }
    
    func loadTasks() async -> [DailyTask] {
        return stubbedLoadTasksResult + stubbedLoadTasksNoDateResult
    }
    
    func update(_ dailyTask: DailyTask) async -> DailyTask? {
        updatedTask = dailyTask
        return dailyTask
    }
    
    func create(_ dailyTask: DailyTask) async -> DailyTask? {
        createdTask = dailyTask
        return dailyTask
    }
    
    func delete(_ dailyTask: DailyTask) async {
        deletedTask = dailyTask
    }
}
