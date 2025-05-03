//
//  DailyTaskTests.swift
//  LvL-upTests
//
//  Created by MyBook on 13.04.2025.
//

import XCTest
@testable import LvL_up

class DailyTaskTests: XCTestCase {
    
    // MARK: - Test Initializers
    
    func testDefaultInit() {
        let date = Date()
        let task = DailyTask(
            id: 1,
            img: "test",
            isCompleted: false,
            reward: 10,
            title: "Test Task",
            checkPoints: 5,
            checkPoint: 2,
            isRepeat: true,
            isArchived: false,
            category: "Health",
            date: date
        )
        
        XCTAssertEqual(task.id, 1)
        XCTAssertEqual(task.img, "test")
        XCTAssertFalse(task.isCompleted)
        XCTAssertEqual(task.reward, 10)
        XCTAssertEqual(task.title, "Test Task")
        XCTAssertEqual(task.checkPoints, 5)
        XCTAssertEqual(task.checkPoint, 2)
        XCTAssertTrue(task.isRepeat)
        XCTAssertFalse(task.isArchived)
        XCTAssertEqual(task.category, "Health")
        XCTAssertEqual(task.date, date)
    }
    
    func testDefaultValuesInit() {
        let task = DailyTask(
            id: 2,
            img: "default",
            isCompleted: true,
            reward: 5,
            title: "Default Task",
            checkPoints: 3,
            category: "Work"
        )
        
        XCTAssertEqual(task.id, 2)
        XCTAssertEqual(task.checkPoint, 0) // Default value
        XCTAssertFalse(task.isRepeat) // Default value
        XCTAssertFalse(task.isArchived) // Default value
        XCTAssertNil(task.date) // Default value
    }
    
    // MARK: - Test Serializer
    
    func testDailyTaskSerializer() {
        let task = DailyTask(
            id: 3,
            img: "serializer",
            isCompleted: false,
            reward: 15,
            title: "Serializer Test",
            checkPoints: 4,
            category: "Education"
        )
        
        let serializer = DailyTaskSerializer(task: task, userId: 123)
        
        XCTAssertEqual(serializer.task.id, task.id)
        XCTAssertEqual(serializer.userId, 123)
    }
    
    // MARK: - Test Update Methods
    
    func testUpdateCurrentProgress() {
        let initialTask = DailyTask(
            id: 4,
            img: "progress",
            isCompleted: false,
            reward: 20,
            title: "Progress Test",
            checkPoints: 5,
            checkPoint: 0,
            category: "Fitness"
        )
        
        // Test partial completion
        let updatedTask1 = initialTask.updateCurrentProgress(3)
        XCTAssertEqual(updatedTask1.checkPoint, 3)
        XCTAssertFalse(updatedTask1.isCompleted)
        
        // Test full completion
        let updatedTask2 = initialTask.updateCurrentProgress(5)
        XCTAssertEqual(updatedTask2.checkPoint, 5)
        XCTAssertTrue(updatedTask2.isCompleted)
        
        // Test no change
        let updatedTask3 = initialTask.updateCurrentProgress(0)
        XCTAssertEqual(updatedTask3.checkPoint, 0)
        XCTAssertFalse(updatedTask3.isCompleted)
    }
    
    // MARK: - Test Reward Calculations
    
    func testCalculateCurrentReward() {
        // Test integer result
        let task1 = DailyTask(
            id: 5,
            img: "reward",
            isCompleted: false,
            reward: 10,
            title: "Reward Test 1",
            checkPoints: 5,
            checkPoint: 3,
            category: "Finance"
        )
        XCTAssertEqual(task1.calculateCurrentReward(), "4") // 10/5*(5-3) = 4
        
        // Test fractional result
        let task2 = DailyTask(
            id: 6,
            img: "reward",
            isCompleted: false,
            reward: 10,
            title: "Reward Test 2",
            checkPoints: 3,
            checkPoint: 1,
            category: "Finance"
        )
        XCTAssertEqual(task2.calculateCurrentReward(), "6.67") // 10/3*(3-1) ≈ 6.666... → 6.67
        
        // Test completed task (zero reward)
        let task3 = DailyTask(
            id: 7,
            img: "reward",
            isCompleted: true,
            reward: 10,
            title: "Reward Test 3",
            checkPoints: 5,
            checkPoint: 5,
            category: "Finance"
        )
        XCTAssertEqual(task3.calculateCurrentReward(), "0")
    }
    
    func testCalculateRewardForCheckPoint() {
        // Test even division
        let task1 = DailyTask(
            id: 8,
            img: "checkpoint",
            isCompleted: false,
            reward: 10,
            title: "Checkpoint Test 1",
            checkPoints: 5,
            category: "Learning"
        )
        XCTAssertEqual(task1.calculateRewardForCheckPoint(), 2.0) // 10/5 = 2
        
        // Test fractional division
        let task2 = DailyTask(
            id: 9,
            img: "checkpoint",
            isCompleted: false,
            reward: 10,
            title: "Checkpoint Test 2",
            checkPoints: 3,
            category: "Learning"
        )
        XCTAssertEqual(task2.calculateRewardForCheckPoint(), 3.3333333, accuracy: 0.000001) // 10/3 ≈ 3.333...
    }
    
    // MARK: - Test Edge Cases
    
    func testZeroCheckPoints() {
        let task = DailyTask(
            id: 10,
            img: "edge",
            isCompleted: false,
            reward: 10,
            title: "Edge Case",
            checkPoints: 0,
            category: "Other"
        )
        
        // These should handle division by zero gracefully
        XCTAssertEqual(task.calculateCurrentReward(), "10")
    }
}
