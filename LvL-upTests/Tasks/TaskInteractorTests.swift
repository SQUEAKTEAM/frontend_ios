//
//  TaskInteractorTests.swift
//  LvL-upTests
//
//  Created by MyBook on 13.04.2025.
//

import XCTest
@testable import LvL_up

class TaskInteractorTests: XCTestCase {
    
    var interactor: TaskInteractor!
    var mockTaskService: MockTaskService!
    
    override func setUp() {
        super.setUp()
        mockTaskService = MockTaskService()
        interactor = TaskInteractor(dataService: mockTaskService)
    }
    
    override func tearDown() {
        interactor = nil
        mockTaskService = nil
        super.tearDown()
    }
    
    // MARK: - Load Tasks Tests
    
    func testLoadTasksReturnsTasksFromService() async {
        // Given
        let expectedTasks = [
            DailyTask(id: 1, img: "test", isCompleted: false, reward: 10, title: "Task 1", checkPoints: 3, category: "Test"),
            DailyTask(id: 2, img: "test", isCompleted: true, reward: 5, title: "Task 2", checkPoints: 1, category: "Test")
        ]
        mockTaskService.stubbedTasks = expectedTasks
        
        // When
        let tasks = await interactor.loadTasks()
        
        // Then
        XCTAssertEqual(tasks.count, 2)
        XCTAssertEqual(tasks.map { $0.id }, expectedTasks.map { $0.id })
    }
    
    func testLoadTasksReturnsEmptyArrayOnServiceError() async {
        // Given
        mockTaskService.shouldThrowError = true
        
        // When
        let tasks = await interactor.loadTasks()
        
        // Then
        XCTAssertTrue(tasks.isEmpty)
    }
    
    func testLoadTasksWithDateFiltersCorrectly() async {
        // Given
        let date = Date()
        let datedTask = DailyTask(id: 1, img: "dated", isCompleted: false, reward: 10, title: "Dated", checkPoints: 3, category: "Test", date: date)
        mockTaskService.stubbedDateFilteredTasks = [datedTask]
        
        // When
        let tasks = await interactor.loadTasks(at: date)
        
        // Then
        XCTAssertEqual(tasks.count, 1)
        XCTAssertEqual(tasks.first?.id, 1)
    }
    
    // MARK: - Create Task Tests
    
    func testCreateTaskReturnsCreatedTask() async {
        // Given
        let newTask = DailyTask(id: 3, img: "new", isCompleted: false, reward: 15, title: "New Task", checkPoints: 2, category: "Test")
        mockTaskService.stubbedCreatedTask = newTask
        
        // When
        await interactor.create(newTask)
        
        // Then
        XCTAssertTrue(mockTaskService.createCalled)
    }
    
    func testCreateTaskReturnsNilOnFailure() async {
        // Given
        let newTask = DailyTask(id: 3, img: "new", isCompleted: false, reward: 15, title: "New Task", checkPoints: 2, category: "Test")
        mockTaskService.shouldThrowError = true
        
        // When
        let result = await interactor.create(newTask)
        
        // Then
        XCTAssertNil(result)
    }
    
    // MARK: - Update Task Tests
    
    func testUpdateTaskReturnsUpdatedTask() async {
        // Given
        let taskToUpdate = DailyTask(id: 1, img: "update", isCompleted: false, reward: 10, title: "To Update", checkPoints: 3, category: "Test")
        mockTaskService.stubbedUpdatedTask = taskToUpdate
        
        // When
        await interactor.update(taskToUpdate)
        
        // Then
        XCTAssertTrue(mockTaskService.updateCalled)
    }
    
    func testUpdateTaskReturnsNilOnFailure() async {
        // Given
        let taskToUpdate = DailyTask(id: 1, img: "update", isCompleted: false, reward: 10, title: "To Update", checkPoints: 3, category: "Test")
        mockTaskService.shouldThrowError = true
        
        // When
        let result = await interactor.update(taskToUpdate)
        
        // Then
        XCTAssertNil(result)
    }
    
    // MARK: - Delete Task Tests
    
    func testDeleteTaskCallsService() async {
        // Given
        let taskToDelete = DailyTask(id: 1, img: "delete", isCompleted: false, reward: 10, title: "To Delete", checkPoints: 3, category: "Test")
        
        // When
        await interactor.delete(taskToDelete)
        
        // Then
        XCTAssertTrue(mockTaskService.deleteCalled)
        XCTAssertEqual(mockTaskService.deletedTaskID, taskToDelete.id)
    }
}

// MARK: - Mock Task Service

class MockTaskService: TaskProviderProtocol {
    var shouldThrowError = false
    
    // For loadTasks()
    var stubbedTasks: [DailyTask] = []
    
    // For loadTasks(at:)
    var stubbedDateFilteredTasks: [DailyTask] = []
    
    // For create/update
    var createCalled = false
    var updateCalled = false
    var stubbedCreatedTask: DailyTask?
    var stubbedUpdatedTask: DailyTask?
    
    // For delete
    var deleteCalled = false
    var deletedTaskID: Int?
    
    func fetchTasks() async throws -> [DailyTask] {
        if shouldThrowError {
            throw NSError(domain: "TestError", code: 1, userInfo: nil)
        }
        return stubbedTasks
    }
    
    func fetchTasks(at date: Date?) async throws -> [DailyTask] {
        if shouldThrowError {
            throw NSError(domain: "TestError", code: 1, userInfo: nil)
        }
        return stubbedDateFilteredTasks
    }
    
    func update(dailyTask: DailyTask) async throws {
        updateCalled = true
        if shouldThrowError {
            throw NSError(domain: "TestError", code: 1, userInfo: nil)
        }
    }
    
    func create(dailyTask: DailyTask) async throws {
        createCalled = true
        if shouldThrowError {
            throw NSError(domain: "TestError", code: 1, userInfo: nil)
        }
    }
    
    func delete(_ id: Int) async throws {
        deleteCalled = true
        deletedTaskID = id
        if shouldThrowError {
            throw NSError(domain: "TestError", code: 1, userInfo: nil)
        }
    }
}
