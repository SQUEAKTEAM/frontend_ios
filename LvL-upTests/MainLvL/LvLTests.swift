//
//  LvLTest.swift
//  LvL-upTests
//
//  Created by MyBook on 11.04.2025.
//

import XCTest
@testable import LvL_up

class LvLTests: XCTestCase {
    
    // MARK: - Initialization Tests
    
    func testInitializationWithDefaultValues() {
        let lvl = LvL.new
        XCTAssertEqual(lvl.currentLvl, 1)
        XCTAssertEqual(lvl.currentExp, 0)
        XCTAssertEqual(lvl.upperBoundExp, 10)
    }
    
    func testInitializationWithCustomValues() {
        let lvl = LvL(currentLvl: 3, currentExp: 25, upperBoundExp: 50)
        XCTAssertEqual(lvl.currentLvl, 3)
        XCTAssertEqual(lvl.currentExp, 25)
        XCTAssertEqual(lvl.upperBoundExp, 50)
    }
    
    // MARK: - Level Up Logic Tests
    
    func testLevelUpWhenExpReachesUpperBound() {
        var lvl = LvL(currentLvl: 1, currentExp: 9, upperBoundExp: 10)
        lvl.currentExp = 10
        
        XCTAssertEqual(lvl.currentLvl, 2)
        XCTAssertEqual(lvl.currentExp, 0)
        XCTAssertEqual(lvl.upperBoundExp, 20)
    }
    
    func testMultipleLevelUps() {
        var lvl = LvL(currentLvl: 1, currentExp: 9, upperBoundExp: 10)
        lvl.currentExp = 35 // Should level up 3 times
        
        XCTAssertEqual(lvl.currentLvl, 4)
        XCTAssertEqual(lvl.currentExp, 5)
        XCTAssertEqual(lvl.upperBoundExp, 40)
    }
    
    // MARK: - Level Down Logic Tests
    func testMultipleLevelDowns() {
        var lvl = LvL(currentLvl: 3, currentExp: 5, upperBoundExp: 30)
        lvl.currentExp = -25 // Should level down 2 times
        
        XCTAssertEqual(lvl.currentLvl, 1)
        XCTAssertEqual(lvl.currentExp, 5)
        XCTAssertEqual(lvl.upperBoundExp, 10)
    }
    
    // MARK: - Edge Cases
    
    func testNoLevelChangeWhenExpJustBelowUpperBound() {
        var lvl = LvL(currentLvl: 1, currentExp: 9.9, upperBoundExp: 10)
        lvl.currentExp = 9.9
        
        XCTAssertEqual(lvl.currentLvl, 1)
        XCTAssertEqual(lvl.currentExp, 9.9)
        XCTAssertEqual(lvl.upperBoundExp, 10)
    }
    
    func testNoLevelChangeWhenExpJustAboveZero() {
        var lvl = LvL(currentLvl: 2, currentExp: 0.1, upperBoundExp: 20)
        lvl.currentExp = 0.1
        
        XCTAssertEqual(lvl.currentLvl, 2)
        XCTAssertEqual(lvl.currentExp, 0.1)
        XCTAssertEqual(lvl.upperBoundExp, 20)
    }
}
