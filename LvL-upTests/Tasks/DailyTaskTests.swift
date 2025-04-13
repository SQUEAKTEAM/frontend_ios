//
//  DailyTaskTests.swift
//  LvL-upTests
//
//  Created by MyBook on 13.04.2025.
//

import XCTest
import CoreData
@testable import LvL_up

class DailyTaskTests: XCTestCase {
    
    // MARK: - Test Initializers
    
    func testDefaultInit() {
        let id = UUID()
        let task = DailyTask(
            id: id,
            currentProgress: 0.5,
            img: "test",
            isCompleted: false,
            reward: 10,
            title: "Test Task",
            upperBounds: 1.0,
            checkPoints: 5
        )
        
        XCTAssertEqual(task.id, id)
        XCTAssertEqual(task.currentProgress, 0.5)
        XCTAssertEqual(task.img, "test")
        XCTAssertFalse(task.isCompleted)
        XCTAssertEqual(task.reward, 10)
        XCTAssertEqual(task.title, "Test Task")
        XCTAssertEqual(task.upperBounds, 1.0)
        XCTAssertEqual(task.checkPoints, 5)
        XCTAssertEqual(task.checkPoint, 0) // Проверка значения по умолчанию
    }
    
    func testEntityInit() {
        let context = TestTaskCoreDataManagerStack().persistentContainer.viewContext
        let entity = DailyTaskEntity(context: context)
        entity.id = UUID()
        entity.currentProgress = 0.75
        entity.img = "entity"
        entity.isCompleted = true
        entity.reward = 15
        entity.title = "Entity Task"
        entity.upperBounds = 2.0
        entity.checkPoints = 3
        entity.checkPoint = 2
        
        let task = DailyTask(entity: entity)
        
        XCTAssertEqual(task.id, entity.id)
        XCTAssertEqual(task.currentProgress, 0.75)
        XCTAssertEqual(task.img, "entity")
        XCTAssertTrue(task.isCompleted)
        XCTAssertEqual(task.reward, 15)
        XCTAssertEqual(task.title, "Entity Task")
        XCTAssertEqual(task.upperBounds, 2.0)
        XCTAssertEqual(task.checkPoints, 3)
        XCTAssertEqual(task.checkPoint, 2)
    }
    
    // MARK: - Test Update Methods
    
    func testUpdateProgressWithCheckPoint() {
        let initialTask = DailyTask(
            id: UUID(),
            currentProgress: 0,
            img: "test",
            isCompleted: false,
            reward: 10,
            title: "Test",
            upperBounds: 10,
            checkPoints: 5
        )
        
        // Test partial completion
        let updatedTask1 = initialTask.updateCurrentProgress(2)
        XCTAssertEqual(updatedTask1.currentProgress, 4.0) // 10/5*2 = 4
        XCTAssertFalse(updatedTask1.isCompleted)
        XCTAssertEqual(updatedTask1.checkPoint, 2)
        
        // Test full completion
        let updatedTask2 = initialTask.updateCurrentProgress(5)
        XCTAssertEqual(updatedTask2.currentProgress, 10.0)
        XCTAssertTrue(updatedTask2.isCompleted)
    }
    
    func testUpdateProgressWithFloatValue() {
        let initialTask = DailyTask(
            id: UUID(),
            currentProgress: 0,
            img: "test",
            isCompleted: false,
            reward: 10,
            title: "Test",
            upperBounds: 10,
            checkPoints: 5
        )
        
        // Test partial completion
        let updatedTask1 = initialTask.updateCurrentProgress(3.0)
        XCTAssertEqual(updatedTask1.checkPoint, 1) // 3/(10/5) = 1.5 → Int = 1
        XCTAssertFalse(updatedTask1.isCompleted)
        
        // Test full completion
        let updatedTask2 = initialTask.updateCurrentProgress(10.0)
        XCTAssertTrue(updatedTask2.isCompleted)
        XCTAssertEqual(updatedTask2.checkPoint, 5)
    }
    
    // MARK: - Test Reward Calculations
    
    func testCalculateCurrentReward() {
        let task = DailyTask(
            id: UUID(),
            currentProgress: 6,
            img: "test",
            isCompleted: false,
            reward: 10,
            title: "Test",
            upperBounds: 10,
            checkPoints: 5,
            checkPoint: 3
        )
        
        // 10/5*(5-3) = 4
        XCTAssertEqual(task.calculateCurrentReward(), "4")
        
        // Test integer value
        let task2 = DailyTask(
            id: UUID(),
            currentProgress: 0,
            img: "test",
            isCompleted: false,
            reward: 15,
            title: "Test",
            upperBounds: 10,
            checkPoints: 3,
            checkPoint: 1
        )
        // 15/3*(3-1) = 10
        XCTAssertEqual(task2.calculateCurrentReward(), "10")
    }
    
    func testCalculateRewardForCheckPoint() {
        let task = DailyTask(
            id: UUID(),
            currentProgress: 0,
            img: "test",
            isCompleted: false,
            reward: 10,
            title: "Test",
            upperBounds: 10,
            checkPoints: 5
        )
        
        XCTAssertEqual(task.calculateRewardForCheckPoint(), 2.0) // 10/5 = 2
    }
}

