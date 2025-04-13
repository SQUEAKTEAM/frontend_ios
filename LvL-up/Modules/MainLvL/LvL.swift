//
//  LvL.swift
//  LvL-up
//
//  Created by MyBook on 09.04.2025.
//

import Foundation
import CoreData

struct LvL: Equatable {
    var currentLvl: Int
    var currentExp: Float {
        didSet {
            if currentExp >= upperBoundExp {
                calculateCurrentData()
            } else if currentExp < 0 {
                calculateReverseData()
            }
        }
    }
    var upperBoundExp: Float
    
    init(entity: LvLEntity) {
        currentLvl = Int(entity.currentLvl)
        upperBoundExp = entity.upperBounds
        currentExp = entity.currentXp
    }
    
    init(currentLvl: Int, currentExp: Float, upperBoundExp: Float) {
        self.currentLvl = currentLvl
        self.currentExp = currentExp
        self.upperBoundExp = upperBoundExp
    }
    
    private mutating func calculateCurrentData() {
        currentLvl += 1
        currentExp = currentExp - upperBoundExp
        upperBoundExp = Float(currentLvl * 10)
    }
    
    private mutating func calculateReverseData() {
        currentLvl -= 1
        upperBoundExp = Float(currentLvl * 10)
        currentExp = currentExp + upperBoundExp
    }
}
