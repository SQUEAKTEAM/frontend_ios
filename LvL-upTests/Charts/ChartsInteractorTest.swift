//
//  ChartsInteractorTest.swift
//  LvL-upTests
//
//  Created by MyBook on 02.05.2025.
//

import XCTest
@testable import LvL_up

final class ChartsInteractorTests: XCTestCase {
    
    // MARK: - Mocks
    
    class MockChartsProvider: ChartsProviderProtocol {
        var fetchDataResult: Result<[Statistics], Error> = .success([])
        
        func fetchData() async throws -> [Statistics] {
            try fetchDataResult.get()
        }
    }
    
    // MARK: - Properties
    
    private var interactor: ChartsInteractorProtocol!
    private var mockProvider: MockChartsProvider!
    
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
        mockProvider = MockChartsProvider()
        interactor = ChartsInteractor(dataService: mockProvider)
    }
    
    override func tearDown() {
        interactor = nil
        mockProvider = nil
        super.tearDown()
    }
    
    // MARK: - Success Tests
    
    func testLoadStatisticsReturnsCorrectData() async {
        // Given
        mockProvider.fetchDataResult = .success(sampleStatistics)
        
        // When
        let result = await interactor.loadStatistics()
        
        // Then
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].id, 1)
        XCTAssertEqual(result[0].countSuccess, 10)
        XCTAssertEqual(result[0].countMiddle, 5)
        XCTAssertEqual(result[0].countFailure, 2)
        XCTAssertEqual(result[0].title, "Test 1")
        XCTAssertEqual(result[1].id, 2)
        XCTAssertEqual(result[1].title, "Test 2")
    }
    
    func testLoadStatisticsWithEmptyArray() async {
        // Given
        mockProvider.fetchDataResult = .success([])
        
        // When
        let result = await interactor.loadStatistics()
        
        // Then
        XCTAssertTrue(result.isEmpty)
    }
    
    // MARK: - Failure Tests
    
    func testLoadStatisticsReturnsEmptyArrayOnError() async {
        // Given
        mockProvider.fetchDataResult = .failure(NSError(
            domain: "test",
            code: 500,
            userInfo: nil
        ))
        
        // When
        let result = await interactor.loadStatistics()
        
        // Then
        XCTAssertTrue(result.isEmpty)
    }
    
    // MARK: - Edge Cases
    
    func testLoadStatisticsWithZeroValues() async {
        // Given
        let zeroStats = Statistics(
            id: 3,
            countSuccess: 0,
            countMiddle: 0,
            countFailure: 0,
            title: "Zero Stats"
        )
        mockProvider.fetchDataResult = .success([zeroStats])
        
        // When
        let result = await interactor.loadStatistics()
        
        // Then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].id, 3)
        XCTAssertEqual(result[0].countSuccess, 0)
        XCTAssertEqual(result[0].countMiddle, 0)
        XCTAssertEqual(result[0].countFailure, 0)
    }
    
    func testLoadStatisticsWithLargeValues() async {
        // Given
        let largeStats = Statistics(
            id: 4,
            countSuccess: Int.max,
            countMiddle: Int.max,
            countFailure: Int.max,
            title: "Large Values"
        )
        mockProvider.fetchDataResult = .success([largeStats])
        
        // When
        let result = await interactor.loadStatistics()
        
        // Then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].countSuccess, Int.max)
    }
}

// Расширение для сравнения Statistics
extension Statistics: Equatable {
    public static func == (lhs: Statistics, rhs: Statistics) -> Bool {
        lhs.id == rhs.id &&
        lhs.countSuccess == rhs.countSuccess &&
        lhs.countMiddle == rhs.countMiddle &&
        lhs.countFailure == rhs.countFailure &&
        lhs.title == rhs.title
    }
}
