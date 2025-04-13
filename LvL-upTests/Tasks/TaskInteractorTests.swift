//
//  TaskInteractorTests.swift
//  LvL-upTests
//
//  Created by MyBook on 13.04.2025.
//

import XCTest
import CoreData
@testable import LvL_up

class TaskInteractorTests: XCTestCase {
    
    var interactor: TaskInteractor!
    var mockDataService: MockTaskProvider!
    
    override func setUp() {
        super.setUp()
        mockDataService = MockTaskProvider()
        interactor = TaskInteractor(dataService: mockDataService)
    }
    
    override func tearDown() {
        interactor = nil
        mockDataService = nil
        super.tearDown()
    }
    
    // MARK: - Load Tasks Tests
    
    func testLoadTasks() {
        // Given
        let testEntity = DailyTaskEntity(context: TestTaskCoreDataManagerStack().persistentContainer.viewContext)
        testEntity.id = UUID()
        testEntity.title = "Test Task"
        mockDataService.stubbedFetchTasksResult = [testEntity]
        
        // When
        let tasks = interactor.loadTasks()
        
        // Then
        XCTAssertEqual(tasks.count, 1)
        XCTAssertEqual(tasks.first?.title, "Test Task")
        XCTAssertTrue(mockDataService.fetchTasksCalled)
    }
    
    // MARK: - Create Task Tests
    
    func testCreateTask() {
        // Given
        let testTask = DailyTask.mockTasks.first!
        var receivedEntity: DailyTaskEntity?
        
        mockDataService.createHook = { entity in
            receivedEntity = entity
        }
        
        // When
        interactor.create(testTask)
        
        // Then
        XCTAssertTrue(mockDataService.createCalled)
        XCTAssertEqual(receivedEntity?.id, testTask.id)
        XCTAssertEqual(receivedEntity?.title, testTask.title)
        XCTAssertEqual(receivedEntity?.reward, Int16(testTask.reward))
    }
    
    // MARK: - Update Task Tests
    
    func testUpdateTask() {
        // Given
        let testTask = DailyTask.mockTasks.first!
        var receivedEntity: DailyTaskEntity?
        
        mockDataService.updateHook = { entity in
            receivedEntity = entity
        }
        
        // When
        interactor.update(testTask)
        
        // Then
        XCTAssertTrue(mockDataService.updateCalled)
        XCTAssertEqual(receivedEntity?.id, testTask.id)
        XCTAssertEqual(receivedEntity?.currentProgress, testTask.currentProgress)
        XCTAssertEqual(receivedEntity?.isCompleted, testTask.isCompleted)
    }
    
    // MARK: - Delete Task Tests
    
    func testDeleteTask() {
        // Given
        let testTask = DailyTask.mockTasks.first!
        
        // When
        interactor.delete(testTask)
        
        // Then
        XCTAssertTrue(mockDataService.deleteCalled)
        XCTAssertEqual(mockDataService.deletedTask?.id, testTask.id)
    }
}

// MARK: - Mock Task Provider

class MockTaskProvider: TaskProviderProtocol {
    var fetchTasksCalled = false
    var stubbedFetchTasksResult: [DailyTaskEntity] = []
    
    var createCalled = false
    var createHook: ((DailyTaskEntity) -> Void)?
    
    var updateCalled = false
    var updateHook: ((DailyTaskEntity) -> Void)?
    
    var deleteCalled = false
    var deletedTask: DailyTask?
    
    func fetchTasks() -> [DailyTaskEntity] {
        fetchTasksCalled = true
        return stubbedFetchTasksResult
    }
    
    func create(dailyTask: DailyTask, _ block: @escaping (DailyTaskEntity) -> Void) {
        createCalled = true
        let entity = DailyTaskEntity(context: TestTaskCoreDataManagerStack().persistentContainer.viewContext)
        block(entity)
        createHook?(entity)
    }
    
    func update(dailyTask: DailyTask, _ block: @escaping (DailyTaskEntity) -> Void) {
        updateCalled = true
        let entity = DailyTaskEntity(context: TestTaskCoreDataManagerStack().persistentContainer.viewContext)
        block(entity)
        updateHook?(entity)
    }
    
    func delete(_ dailyTask: DailyTask) {
        deleteCalled = true
        deletedTask = dailyTask
    }
}
