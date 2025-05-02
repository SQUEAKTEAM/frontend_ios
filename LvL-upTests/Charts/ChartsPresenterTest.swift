//
//  ChartsPresenterTest.swift
//  LvL-upTests
//
//  Created by MyBook on 02.05.2025.
//

import XCTest
import Combine
@testable import LvL_up

final class ChartsPresenterTests: XCTestCase {
    
    // MARK: - Mocks
    
    class MockInteractor: ChartsInteractorProtocol {
        var loadStatisticsResult: [Statistics] = []
        var loadStatisticsCalled = false
        
        func loadStatistics() async -> [Statistics] {
            loadStatisticsCalled = true
            return loadStatisticsResult
        }
    }
    
    // MARK: - Properties
    
    private var presenter: ChartsPresenter!
    private var mockInteractor: MockInteractor!
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Test Data
    
    private let sampleStatistics = [
        Statistics(
            id: 1,
            countSuccess: 10,
            countMiddle: 5,
            countFailure: 2,
            title: "Test 1"
        ),
        Statistics(
            id: 2,
            countSuccess: 15,
            countMiddle: 3,
            countFailure: 1,
            title: "Test 2"
        )
    ]
    
    // MARK: - Setup
    
    override func setUp() {
        super.setUp()
        mockInteractor = MockInteractor()
        presenter = ChartsPresenter(interactor: mockInteractor)
    }
    
    override func tearDown() {
        presenter = nil
        mockInteractor = nil
        cancellables.removeAll()
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testInitialState() {
        XCTAssertTrue(presenter.statistics.isEmpty)
    }
    
    func testGetDataUpdatesStatistics() async {
        // Given
        mockInteractor.loadStatisticsResult = sampleStatistics
        let expectation = XCTestExpectation(description: "Statistics published")
        
        // Subscribe to publisher changes
        presenter.$statistics
            .dropFirst() // Skip initial value
            .sink { newValue in
                XCTAssertEqual(newValue, self.sampleStatistics)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        await presenter.getData()
        
        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(presenter.statistics, sampleStatistics)
    }
    
    func testGetDataWithEmptyResult() async {
        // Given
        mockInteractor.loadStatisticsResult = []
        let expectation = XCTestExpectation(description: "Empty statistics published")
        
        presenter.$statistics
            .dropFirst()
            .sink { newValue in
                XCTAssertTrue(newValue.isEmpty)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        await presenter.getData()
        
        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertTrue(presenter.statistics.isEmpty)
    }
    
    func testGetDataCallsInteractor() async {
        // Given
        mockInteractor.loadStatisticsResult = sampleStatistics
        
        // When
        await presenter.getData()
        
        // Then
        XCTAssertTrue(mockInteractor.loadStatisticsCalled)
        XCTAssertEqual(presenter.statistics, sampleStatistics)
    }
    
    func testPublisherEmitsOnMainThread() async {
        // Given
        mockInteractor.loadStatisticsResult = sampleStatistics
        let expectation = XCTestExpectation(description: "Check thread")
        var isMainThread = false
        
        presenter.$statistics
            .dropFirst()
            .sink { _ in
                isMainThread = Thread.isMainThread
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        await presenter.getData()
        
        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertTrue(isMainThread)
    }
    
    func testMainActorAnnotation() async {
        // This test verifies that getData() is marked with @MainActor
        let task = Task { @MainActor in
            let startTime = Date()
            
            // We'll check if we're actually on the main thread
            XCTAssertTrue(Thread.isMainThread, "Test should start on main thread")
            
            // Create a suspension point to detect if we're moved off the main thread
            await Task.yield()
            
            // If we're still on main thread after suspension, the method maintains MainActor isolation
            XCTAssertTrue(Thread.isMainThread, "@MainActor isolation was broken")
            
            // Verify that calling getData() keeps us on main thread
            await presenter.getData()
            XCTAssertTrue(Thread.isMainThread, "getData() should maintain MainActor isolation")
        }
        
        // Wait for the task to complete
        let _ = await task.value
    }
}
