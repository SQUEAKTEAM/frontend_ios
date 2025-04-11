//
//  LvLDataProvider.swift
//  LvL-up
//
//  Created by MyBook on 11.04.2025.
//

import Foundation
import CoreData

final class LvLCoreDataProvider: LvLDataProviderProtocol {
    private let coreDataManager: CoreDataManager<LvLEntity>
    
    init(coreDataManager: CoreDataManager<LvLEntity> = CoreDataManager<LvLEntity>()) {
        self.coreDataManager = coreDataManager
    }
    
    func fetchLvl() -> LvLEntity {
        if let existing = coreDataManager.fetchAll().first {
            return existing
        } else {
            let newLevel = coreDataManager.create()
            newLevel.currentLvl = 1
            newLevel.upperBounds = 10
            newLevel.currentXp = 0
            return newLevel
        }
    }
    
    func update(_ block: @escaping (LvLEntity) -> Void) {
        let level = fetchLvl()
        coreDataManager.update {
            block(level)
        }
    }
}

