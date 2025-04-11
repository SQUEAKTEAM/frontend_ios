//
//  LvLTest.swift
//  LvL-upTests
//
//  Created by MyBook on 11.04.2025.
//

import XCTest
import CoreData
@testable import LvL_up

class LvLTests: XCTestCase {
    
    func testInitFromEntity() {
        // Given
        let entity = LvLEntity(context: TestCoreDataManagerStack().persistentContainer.viewContext)
        entity.currentLvl = 7
        entity.upperBounds = 70
        entity.currentXp = 35
        
        // When
        let lvl = LvL(entity: entity)
        
        // Then
        XCTAssertEqual(lvl.currentLvl, 7)
        XCTAssertEqual(lvl.currentExp, 35)
        XCTAssertEqual(lvl.upperBoundExp, 70)
    }
    
    func testCalculateCurrentDataWhenExpExceedsUpperBound() {
        // Given
        var lvl = LvL(currentLvl: 1, currentExp: 15, upperBoundExp: 10)
        
        // When
        lvl.currentExp = 15 // triggers didSet
        
        // Then
        XCTAssertEqual(lvl.currentLvl, 2)
        XCTAssertEqual(lvl.currentExp, 5)
        XCTAssertEqual(lvl.upperBoundExp, 20)
    }
    
    func testCalculateCurrentDataWhenExpDoesNotExceedUpperBound() {
        // Given
        var lvl = LvL(currentLvl: 1, currentExp: 5, upperBoundExp: 10)
        
        // When
        lvl.currentExp = 8 // triggers didSet
        
        // Then
        XCTAssertEqual(lvl.currentLvl, 1)
        XCTAssertEqual(lvl.currentExp, 8)
        XCTAssertEqual(lvl.upperBoundExp, 10)
    }
}
