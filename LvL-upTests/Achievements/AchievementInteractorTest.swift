//
//  AchievementInteractorTest.swift
//  LvL-upTests
//
//  Created by MyBook on 02.05.2025.
//

import XCTest
@testable import LvL_up

// MARK: - Mocks

class MockAchievementProvider: AchievementProviderProtocol {
    var fetchDataResult: Result<[Achievement], Error> = .success([])
    
    func fetchData() async throws -> [Achievement] {
        switch fetchDataResult {
        case .success(let achievements):
            return achievements
        case .failure(let error):
            throw error
        }
    }
}

// MARK: - Test Data

extension Achievement {
    static func testAchievement(
        id: Int = 1,
        title: String = "Test Achievement",
        currentXp: Int = 50,
        upperBounds: Int = 100,
        reward: Int = 10,
        isCompleted: Bool = false
    ) -> Achievement {
        Achievement(
            id: id,
            title: title,
            currentXp: currentXp,
            upperBounds: upperBounds,
            reward: reward,
            isCompleted: isCompleted
        )
    }
}

// MARK: - Tests

class AchievementInteractorTests: XCTestCase {
    
    var interactor: AchievementInteractorProtocol!
    var mockProvider: MockAchievementProvider!
    
    override func setUp() {
        super.setUp()
        mockProvider = MockAchievementProvider()
        interactor = AchievementInteractor(dataService: mockProvider)
    }
    
    override func tearDown() {
        interactor = nil
        mockProvider = nil
        super.tearDown()
    }
    
    // MARK: - Success Cases
    
    func testLoadAchievements_ReturnsCorrectData() async {
        // Given
        let testAchievements = [
            Achievement.testAchievement(id: 1, title: "First Steps", currentXp: 30, isCompleted: false),
            Achievement.testAchievement(id: 2, title: "Master", currentXp: 100, isCompleted: true)
        ]
        mockProvider.fetchDataResult = .success(testAchievements)
        
        // When
        let result = await interactor.loadAchievements()
        
        // Then
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].id, 1)
        XCTAssertEqual(result[0].title, "First Steps")
        XCTAssertEqual(result[0].currentXp, 30)
        XCTAssertFalse(result[0].isCompleted)
        XCTAssertEqual(result[1].id, 2)
        XCTAssertTrue(result[1].isCompleted)
    }
    
    func testLoadAchievements_EmptyResponse_ReturnsEmptyArray() async {
        // Given
        mockProvider.fetchDataResult = .success([])
        
        // When
        let result = await interactor.loadAchievements()
        
        // Then
        XCTAssertTrue(result.isEmpty)
    }
    
    // MARK: - Failure Cases
    
    func testLoadAchievements_WhenServiceFails_ReturnsEmptyArray() async {
        // Given
        mockProvider.fetchDataResult = .failure(NSError(domain: "test", code: 500))
        
        // When
        let result = await interactor.loadAchievements()
        
        // Then
        XCTAssertTrue(result.isEmpty)
    }
    
    // MARK: - Edge Cases
    
    func testLoadAchievements_PartialData_HandlesCorrectly() async {
        // Given
        let testAchievements = [
            Achievement.testAchievement(id: 1, currentXp: 0, upperBounds: 0, reward: 0),
            Achievement.testAchievement(id: 2, currentXp: -10, upperBounds: -100, reward: -5)
        ]
        mockProvider.fetchDataResult = .success(testAchievements)
        
        // When
        let result = await interactor.loadAchievements()
        
        // Then
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].currentXp, 0)
        XCTAssertEqual(result[1].currentXp, -10) // Проверяем, что негативные значения обрабатываются
    }
}

// MARK: - Helper

enum MockError: Error {
    case testError
}
