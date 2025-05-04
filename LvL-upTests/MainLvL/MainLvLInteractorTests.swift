//
//  MainLvLInteractorTest.swift
//  LvL-upTests
//
//  Created by MyBook on 11.04.2025.
//

import XCTest
@testable import LvL_up

class MainLvLInteractorTests: XCTestCase {
    
    var interactor: MainLvLInteractor!
    var mockDataService: MockLvLProvider!
    
    override func setUp() {
        super.setUp()
        mockDataService = MockLvLProvider()
        interactor = MainLvLInteractor(dataService: mockDataService)
    }
    
    override func tearDown() {
        interactor = nil
        mockDataService = nil
        super.tearDown()
    }
    
    // MARK: - Load Level Tests
    
    func testLoadLvlReturnsDataFromService() async {
        // Given
        let expectedLvl = LvL(currentLvl: 5, currentExp: 50, upperBoundExp: 100)
        mockDataService.stubbedFetchDataResult = expectedLvl
        
        // When
        let result = await interactor.loadLvl()
        
        // Then
        XCTAssertEqual(result, expectedLvl)
        XCTAssertTrue(mockDataService.fetchDataCalled)
    }
    
    func testLoadLvlReturnsNewLvlWhenServiceFails() async {
        // Given
        mockDataService.stubbedFetchDataError = NSError(domain: "TestError", code: 1)
        
        // When
        let result = await interactor.loadLvl()
        
        // Then
        XCTAssertEqual(result, LvL.new)
        XCTAssertTrue(mockDataService.fetchDataCalled)
    }
    
    // MARK: - Update Level Tests
    
    func testUpdateCallsServiceWithCorrectData() async {
        // Given
        let lvlToUpdate = LvL(currentLvl: 3, currentExp: 30, upperBoundExp: 60)
        
        // When
        await interactor.update(lvlToUpdate)
        
        // Then
        XCTAssertTrue(mockDataService.updateCalled)
        XCTAssertEqual(mockDataService.updatedLvl, lvlToUpdate)
    }
    
    func testUpdateDoesNothingWhenNilPassed() async {
        // When
        await interactor.update(nil)
        
        // Then
        XCTAssertFalse(mockDataService.updateCalled)
    }
    
    func testUpdateDoesNotThrowWhenServiceFails() async {
        // Given
        mockDataService.stubbedUpdateError = NSError(domain: "TestError", code: 1)
        let lvlToUpdate = LvL(currentLvl: 2, currentExp: 20, upperBoundExp: 40)
        
        // When
        await interactor.update(lvlToUpdate)
        
        // Then
        XCTAssertTrue(mockDataService.updateCalled)
    }
}

// MARK: - Mock LvLProvider

class MockLvLProvider: LvLProviderProtocol {
    var fetchDataCalled = false
    var stubbedFetchDataResult: LvL = LvL.new
    var stubbedFetchDataError: Error?
    
    var updateCalled = false
    var updatedLvl: LvL?
    var stubbedUpdateError: Error?
    
    func fetchData() async throws -> LvL {
        fetchDataCalled = true
        if let error = stubbedFetchDataError {
            throw error
        }
        return stubbedFetchDataResult
    }
    
    func update(lvl: LvL) async throws {
        updateCalled = true
        updatedLvl = lvl
        if let error = stubbedUpdateError {
            throw error
        }
    }
}
