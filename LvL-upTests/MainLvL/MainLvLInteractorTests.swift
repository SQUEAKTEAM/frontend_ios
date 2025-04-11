//
//  MainLvLInteractorTest.swift
//  LvL-upTests
//
//  Created by MyBook on 11.04.2025.
//

import XCTest
import CoreData
@testable import LvL_up

class MainLvLInteractorTests: XCTestCase {
    
    var interactor: MainLvLInteractor!
    var mockDataService: MockLvLDataProvider!
    
    override func setUp() {
        super.setUp()
        mockDataService = MockLvLDataProvider()
        interactor = MainLvLInteractor(dataService: mockDataService)
    }
    
    override func tearDown() {
        interactor = nil
        mockDataService = nil
        super.tearDown()
    }
    
    func testLoadLvlReturnsCorrectLvL() {
        // Given
        let entity = LvLEntity(context: TestCoreDataManagerStack().persistentContainer.viewContext)
        entity.currentLvl = 10
        entity.upperBounds = 100
        entity.currentXp = 50
        mockDataService.stubbedFetchLvlResult = entity
        
        // When
        let result = interactor.loadLvl()
        
        // Then
        XCTAssertEqual(result.currentLvl, 10)
        XCTAssertEqual(result.currentExp, 50)
        XCTAssertEqual(result.upperBoundExp, 100)
        XCTAssertTrue(mockDataService.fetchLvlCalled)
    }
    
    func testUpdateCallsDataServiceUpdate() {
        // Given
        let expectation = XCTestExpectation(description: "Data service update called")
        
        // Создаем тестовую LvLEntity
        let testEntity = LvLEntity(context: TestCoreDataManagerStack().persistentContainer.viewContext)
        testEntity.currentLvl = 5
        testEntity.upperBounds = 100
        testEntity.currentXp = 50
        
        // Настраиваем мок
        mockDataService.stubbedFetchLvlResult = testEntity
        mockDataService.updateCalledHandler = { entity in
            // Проверяем, что entity передается корректно
            XCTAssertEqual(entity.currentLvl, 5)
            XCTAssertEqual(entity.upperBounds, 100)
            XCTAssertEqual(entity.currentXp, 50)
            expectation.fulfill()
        }
        
        // When
        let testLvl = LvL(currentLvl: 5, currentExp: 50, upperBoundExp: 100)
        interactor.update(testLvl)
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(mockDataService.updateCalled)
        
        // Дополнительная проверка, что данные были обновлены
        XCTAssertEqual(testEntity.currentLvl, 5)
        XCTAssertEqual(testEntity.upperBounds, 100)
        XCTAssertEqual(testEntity.currentXp, 50)
    }
}

// MARK: - Mock LvLDataProvider

class MockLvLDataProvider: LvLDataProviderProtocol {
    var fetchLvlCalled = false
    var stubbedFetchLvlResult: LvLEntity!
    var updateCalled = false
    var updateCalledHandler: ((LvLEntity) -> Void)?
    
    func fetchLvl() -> LvLEntity {
        fetchLvlCalled = true
        return stubbedFetchLvlResult
    }
    
    func update(_ block: @escaping (LvLEntity) -> Void) {
        updateCalled = true
        if let entity = stubbedFetchLvlResult {
            block(entity)
        }
        updateCalledHandler?(stubbedFetchLvlResult)
    }
}
