//
//  MainLvLInteractor.swift
//  LvL-up
//
//  Created by MyBook on 11.04.2025.
//

import Foundation

protocol LvLProviderProtocol {
    func fetchData() async throws -> LvL
    func update(lvl: LvL) async throws
}

protocol MainLvLInteractorProtocol {
    func loadLvl() async -> LvL
    func update(_ mainLvl: LvL?) async
}

final class MainLvLInteractor: MainLvLInteractorProtocol {
    private let dataService: LvLProviderProtocol
    
    init(dataService: LvLProviderProtocol = LvLDataProvider()) {
        self.dataService = dataService
    }
    
    func loadLvl() async -> LvL {
        (try? await dataService.fetchData()) ?? LvL.new
    }
    
    func update(_ mainLvl: LvL?) async {
        guard let lvl = mainLvl else { return }
        try? await dataService.update(lvl: lvl)
    }
}
