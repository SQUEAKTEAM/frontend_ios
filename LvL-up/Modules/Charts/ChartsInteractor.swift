//
//  ChartsInteractor.swift
//  LvL-up
//
//  Created by MyBook on 02.05.2025.
//

import Foundation

protocol ChartsProviderProtocol {
    func fetchData() async throws -> [Statistics]
}

protocol ChartsInteractorProtocol {
    func loadStatistics() async -> [Statistics]
}

final class ChartsInteractor: ChartsInteractorProtocol {
    
    private let dataService: ChartsProviderProtocol
    
    init(dataService: ChartsProviderProtocol = ChartsDataProvider()) {
        self.dataService = dataService
    }
    
    func loadStatistics() async -> [Statistics] {
        return (try? await dataService.fetchData()) ?? []
    }
}
