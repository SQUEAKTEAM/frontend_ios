//
//  DailyStatsInteractor.swift
//  LvL-up
//
//  Created by MyBook on 22.05.2025.
//

import Foundation

protocol DailyStatsProviderProtocol {
    func fetchData() async throws -> DailyStats
}

protocol DailyStatsInteractorProtocol {
    func loadDailyStats() async -> DailyStats?
}

final class DailyStatsInteractor: DailyStatsInteractorProtocol {
    
    private let dataService: DailyStatsProviderProtocol
    
    init(dataService: DailyStatsProviderProtocol = DailyStatsProvider()) {
        self.dataService = dataService
    }
    
    func loadDailyStats() async -> DailyStats? {
        return try? await dataService.fetchData()
    }
}
