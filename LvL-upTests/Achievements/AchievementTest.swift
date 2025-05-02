//
//  AchievementTest.swift
//  LvL-upTests
//
//  Created by MyBook on 02.05.2025.
//

import XCTest
@testable import LvL_up

class AchievementTests: XCTestCase {
    
    // MARK: - Test Data
    
    private let sampleAchievement = Achievement(
        id: 1,
        title: "Test Achievement",
        currentXp: 5,
        upperBounds: 10,
        reward: 20,
        isCompleted: false
    )
    
    // MARK: - Initialization Tests
    
    func testAchievementInitialization() {
        let achievement = Achievement(
            id: 2,
            title: "Initialization Test",
            currentXp: 3,
            upperBounds: 5,
            reward: 15,
            isCompleted: true
        )
        
        XCTAssertEqual(achievement.id, 2)
        XCTAssertEqual(achievement.title, "Initialization Test")
        XCTAssertEqual(achievement.currentXp, 3)
        XCTAssertEqual(achievement.upperBounds, 5)
        XCTAssertEqual(achievement.reward, 15)
        XCTAssertTrue(achievement.isCompleted)
    }
    
    // MARK: - ConvertToDailyTask Tests
    
    func testConvertToDailyTask() {
        let dailyTask = sampleAchievement.convertToDailyTask()
        
        XCTAssertEqual(dailyTask.title, sampleAchievement.title)
        XCTAssertEqual(dailyTask.currentProgress, Float(sampleAchievement.currentXp))
        XCTAssertEqual(dailyTask.upperBounds, Float(sampleAchievement.upperBounds))
        XCTAssertEqual(dailyTask.reward, sampleAchievement.reward)
        XCTAssertEqual(dailyTask.isCompleted, sampleAchievement.isCompleted)
        XCTAssertEqual(dailyTask.img, "medal.fill")
        XCTAssertEqual(dailyTask.checkPoints, 1)
    }
    
    func testConvertCompletedAchievementToDailyTask() {
        let completedAchievement = sampleAchievement.updateCurrentXp(10)
        let dailyTask = completedAchievement.convertToDailyTask()
        
        XCTAssertTrue(dailyTask.isCompleted)
        XCTAssertEqual(dailyTask.currentProgress, dailyTask.upperBounds)
    }
    
    // MARK: - UpdateCurrentXp Tests
    
    func testUpdateCurrentXp() {
        let newXp = 7
        let updated = sampleAchievement.updateCurrentXp(newXp)
        
        XCTAssertEqual(updated.currentXp, newXp)
        XCTAssertEqual(updated.id, sampleAchievement.id)
        XCTAssertEqual(updated.title, sampleAchievement.title)
        XCTAssertEqual(updated.upperBounds, sampleAchievement.upperBounds)
        XCTAssertEqual(updated.reward, sampleAchievement.reward)
        XCTAssertEqual(updated.isCompleted, sampleAchievement.isCompleted)
    }
    
    func testUpdateXpMarksAsCompleted() {
        let updated = sampleAchievement.updateCurrentXp(sampleAchievement.upperBounds)
        XCTAssertTrue(updated.isCompleted)
    }
    
    func testUpdateXpDoesNotMarkAsCompletedWhenBelowUpperBounds() {
        let updated = sampleAchievement.updateCurrentXp(sampleAchievement.upperBounds - 1)
        XCTAssertFalse(updated.isCompleted)
    }
    
    // MARK: - Edge Cases
    
    func testZeroUpperBounds() {
        let achievement = Achievement(
            id: 3,
            title: "Zero Bounds",
            currentXp: 0,
            upperBounds: 0,
            reward: 0,
            isCompleted: false
        )
        
        XCTAssertTrue(achievement.updateCurrentXp(0).isCompleted)
    }
    
    func testNegativeValues() {
        let achievement = Achievement(
            id: 4,
            title: "Negative Values",
            currentXp: -5,
            upperBounds: -10,
            reward: -20,
            isCompleted: false
        )
        
        XCTAssertFalse(achievement.isCompleted)
        let updated = achievement.updateCurrentXp(-10)
        XCTAssertTrue(updated.isCompleted)
    }
    
    // MARK: - Identifiable Conformance
    
    func testIdentifiableConformance() {
        XCTAssertEqual(sampleAchievement.id, sampleAchievement.id)
    }
    
    // MARK: - Completion State Tests
    
    func testIsCompletedComputedProperly() {
        let notCompleted = sampleAchievement.updateCurrentXp(sampleAchievement.upperBounds - 1)
        XCTAssertFalse(notCompleted.isCompleted)
        
        let justCompleted = sampleAchievement.updateCurrentXp(sampleAchievement.upperBounds)
        XCTAssertTrue(justCompleted.isCompleted)
        
        let overCompleted = sampleAchievement.updateCurrentXp(sampleAchievement.upperBounds + 5)
        XCTAssertTrue(overCompleted.isCompleted)
    }
    
    // MARK: - Equality Tests
    
    func testAchievementEquality() {
        let sameAchievement = Achievement(
            id: sampleAchievement.id,
            title: sampleAchievement.title,
            currentXp: sampleAchievement.currentXp,
            upperBounds: sampleAchievement.upperBounds,
            reward: sampleAchievement.reward,
            isCompleted: sampleAchievement.isCompleted
        )
        
        XCTAssertEqual(sampleAchievement, sameAchievement)
        
        let differentAchievement = sampleAchievement.updateCurrentXp(sampleAchievement.currentXp + 1)
        XCTAssertNotEqual(sampleAchievement, differentAchievement)
    }
}

// MARK: - Equatable Extension for Testing

extension Achievement: Equatable {
    public static func == (lhs: Achievement, rhs: Achievement) -> Bool {
        lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.currentXp == rhs.currentXp &&
        lhs.upperBounds == rhs.upperBounds &&
        lhs.reward == rhs.reward &&
        lhs.isCompleted == rhs.isCompleted
    }
}
