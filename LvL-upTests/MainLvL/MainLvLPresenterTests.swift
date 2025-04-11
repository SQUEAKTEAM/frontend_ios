//
//  MainLvLPresenterTest.swift
//  LvL-upTests
//
//  Created by MyBook on 11.04.2025.
//

import XCTest
import Combine
@testable import LvL_up

class MainLvLPresenterTests: XCTestCase {
    
    var presenter: MainLvLPresenter!
    var mockInteractor: MockMainLvLInteractor!
    var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        mockInteractor = MockMainLvLInteractor()
        presenter = MainLvLPresenter(interactor: mockInteractor)
    }
    
    override func tearDown() {
        presenter = nil
        mockInteractor = nil
        cancellables = []
        super.tearDown()
    }
    
    func testGetDataUpdatesLvl() async {
        // Given
        let expectedLvl = LvL(currentLvl: 5, currentExp: 50, upperBoundExp: 100)
        mockInteractor.stubbedLoadLvlResult = expectedLvl
        
        // When
        await presenter.getData()
        
        // Then
        XCTAssertEqual(presenter.lvl?.currentLvl, expectedLvl.currentLvl)
        XCTAssertEqual(presenter.lvl?.currentExp, expectedLvl.currentExp)
        XCTAssertEqual(presenter.lvl?.upperBoundExp, expectedLvl.upperBoundExp)
        XCTAssertTrue(mockInteractor.loadLvlCalled)
    }
    
    func testLvlUpdateCallsInteractorUpdate() {
        // Given
        let expectation = XCTestExpectation(description: "Interactor update called")
        mockInteractor.updateCalledHandler = { _ in
            expectation.fulfill()
        }
        
        // When
        let testLvl = LvL(currentLvl: 3, currentExp: 30, upperBoundExp: 60)
        presenter.lvl = testLvl
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(mockInteractor.updatedLvl)
    }
}

// MARK: - Mock MainLvLInteractor

class MockMainLvLInteractor: MainLvLInteractorProtocol {
    var loadLvlCalled = false
    var stubbedLoadLvlResult: LvL!
    var updatedLvl: LvL?
    var updateCalledHandler: ((LvL?) -> Void)?
    
    func loadLvl() -> LvL {
        loadLvlCalled = true
        return stubbedLoadLvlResult
    }
    
    func update(_ mainLvl: LvL?) {
        updatedLvl = mainLvl
        updateCalledHandler?(mainLvl)
    }
}
