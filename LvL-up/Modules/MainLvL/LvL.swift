//
//  LvL.swift
//  LvL-up
//
//  Created by MyBook on 09.04.2025.
//

import Foundation
import CoreData

struct LvL {
    var currentLvl: Int
    var currentExp: Float {
        didSet {
            if currentExp >= upperBoundExp {
                calculateCurrentData()
            }
        }
    }
    var upperBoundExp: Float
    
    init(entity: LvLEntity) {
        currentLvl = Int(entity.currentLvl)
        upperBoundExp = Float(entity.upperBounds)
        currentExp = Float(entity.currentXp)
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
}
