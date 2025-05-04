//
//  MainLvLPresenterTest.swift
//  LvL-upTests
//
//  Created by MyBook on 11.04.2025.
//

import XCTest
@testable import LvL_up

class MainLvLPresenterTests: XCTestCase {
    
    var presenter: MainLvLPresenter!
    var mockInteractor: MockMainLvLInteractor!
    
    override func setUp() {
        super.setUp()
        mockInteractor = MockMainLvLInteractor()
        presenter = MainLvLPresenter(interactor: mockInteractor)
    }
    
    override func tearDown() {
        presenter = nil
        mockInteractor = nil
        super.tearDown()
    }
    
    // MARK: - Initial State Tests
    
    func testInitialState() {
        XCTAssertNil(presenter.lvl)
    }
    
    // MARK: - Get Data Tests
    
    func testGetDataUpdatesLvlProperty() async {
        // Given
        let expectedLvl = LvL(currentLvl: 5, currentExp: 50, upperBoundExp: 100)
        mockInteractor.stubbedLoadLvlResult = expectedLvl
        
        // When
        await presenter.getData()
        
        // Then
        XCTAssertEqual(presenter.lvl, expectedLvl)
        XCTAssertTrue(mockInteractor.loadLvlCalled)
    }
    
    // MARK: - Lvl Property Observer Tests
    
    func testLvlDidSetCallsUpdate() async {
        // Given
        let expectation = XCTestExpectation(description: "Update called")
        mockInteractor.updateHandler = { _ in
            expectation.fulfill()
        }
        
        // When
        let newLvl = LvL(currentLvl: 2, currentExp: 20, upperBoundExp: 40)
        await MainActor.run {
            presenter.lvl = newLvl
        }
        
        // Then
        await fulfillment(of: [expectation], timeout: 1)
        XCTAssertEqual(mockInteractor.updatedLvl, newLvl)
    }
}

// MARK: - Mock MainLvLInteractor

class MockMainLvLInteractor: MainLvLInteractorProtocol {
    var loadLvlCalled = false
    var loadLvlCallCount = 0
    var stubbedLoadLvlResult: LvL = LvL.new
    
    var updateCalled = false
    var updateCallCount = 0
    var updatedLvl: LvL?
    var updateHandler: ((LvL?) -> Void)?
    
    func loadLvl() async -> LvL {
        loadLvlCalled = true
        loadLvlCallCount += 1
        return stubbedLoadLvlResult
    }
    
    func update(_ mainLvl: LvL?) async {
        updateCalled = true
        updateCallCount += 1
        updatedLvl = mainLvl
        updateHandler?(mainLvl)
    }
}
