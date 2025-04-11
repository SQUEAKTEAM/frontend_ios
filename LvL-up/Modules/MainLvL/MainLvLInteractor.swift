//
//  MainLvLInteractor.swift
//  LvL-up
//
//  Created by MyBook on 11.04.2025.
//

import Foundation
import CoreData

protocol LvLDataProviderProtocol {
    func fetchLvl() -> LvLEntity
    func update(_ block: @escaping (LvLEntity) -> Void)
}

protocol MainLvLInteractorProtocol {
    func loadLvl() -> LvL
    func update(_ mainLvl: LvL?)
}

final class MainLvLInteractor: MainLvLInteractorProtocol {
    
    private let dataService: LvLDataProviderProtocol
    
    init(dataService: LvLDataProviderProtocol = LvLCoreDataProvider()) {
        self.dataService = dataService
    }
    
    func loadLvl() -> LvL {
        return LvL(entity: dataService.fetchLvl())
    }
    
    func update(_ mainLvl: LvL?) {
        dataService.update { level in
            guard let mainLvl = mainLvl else { return }
            
            level.currentLvl = Int32(mainLvl.currentLvl)
            level.upperBounds = Int32(mainLvl.upperBoundExp)
            level.currentXp = Int32(mainLvl.currentExp)
        }
    }
}
