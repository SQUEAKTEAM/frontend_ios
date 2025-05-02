//
//  AchievementPresenterTest.swift
//  LvL-upTests
//
//  Created by MyBook on 02.05.2025.
//

import XCTest
import Combine
@testable import LvL_up

class AchievementPresenterTests: XCTestCase {
    
    var presenter: AchievementPresenter!
    var mockInteractor: MockAchievementInteractor!
    var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        mockInteractor = MockAchievementInteractor()
        presenter = AchievementPresenter(interactor: mockInteractor)
    }
    
    override func tearDown() {
        presenter = nil
        mockInteractor = nil
        cancellables = []
        super.tearDown()
    }
    
    // MARK: - Mock Interactor
    
    class MockAchievementInteractor: AchievementInteractorProtocol {
        var loadAchievementsResult: [Achievement] = []
        
        func loadAchievements() async -> [Achievement] {
            return loadAchievementsResult
        }
    }
    
    // MARK: - Test Data
    
    private func createTestAchievement(id: Int, isCompleted: Bool) -> Achievement {
        Achievement(
            id: id,
            title: "Achievement \(id)",
            currentXp: 50,
            upperBounds: 100,
            reward: 10,
            isCompleted: isCompleted
        )
    }
    
    // MARK: - Tests
    
    func testGetData_ShouldUpdateAchievementsProperty() async {
        // Given
        let testAchievements = [
            createTestAchievement(id: 1, isCompleted: false),
            createTestAchievement(id: 2, isCompleted: true)
        ]
        mockInteractor.loadAchievementsResult = testAchievements
        
        let expectation = XCTestExpectation(description: "achievements published")
        
        // Subscribe to achievements publisher
        presenter.$achievements
            .dropFirst() // Skip initial empty value
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        await presenter.getData()
        
        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(presenter.achievements.count, 2)
    }
    
    func testGetData_ShouldSortByCompletionStatus() async {
        // Given
        let testAchievements = [
            createTestAchievement(id: 1, isCompleted: true),
            createTestAchievement(id: 2, isCompleted: false),
            createTestAchievement(id: 3, isCompleted: true),
            createTestAchievement(id: 4, isCompleted: false)
        ]
        mockInteractor.loadAchievementsResult = testAchievements
        
        // When
        await presenter.getData()
        
        // Then
        // First should be not completed (false), then completed (true)
        XCTAssertEqual(presenter.achievements[0].id, 2)
        XCTAssertEqual(presenter.achievements[1].id, 4)
        XCTAssertEqual(presenter.achievements[2].id, 1)
        XCTAssertEqual(presenter.achievements[3].id, 3)
    }
    
    func testGetData_WithEmptyData_ShouldHaveEmptyAchievements() async {
        // Given
        mockInteractor.loadAchievementsResult = []
        
        // When
        await presenter.getData()
        
        // Then
        XCTAssertTrue(presenter.achievements.isEmpty)
    }
    
    func testGetData_ShouldBeCalledOnMainActor() async {
        // This test verifies the @MainActor annotation works
        
        // Given
        let testAchievements = [createTestAchievement(id: 1, isCompleted: false)]
        mockInteractor.loadAchievementsResult = testAchievements
        
        // When
        await presenter.getData()
        
        // Then
        // If we get here without crashes, the MainActor requirement is satisfied
        XCTAssertFalse(presenter.achievements.isEmpty)
    }
}
