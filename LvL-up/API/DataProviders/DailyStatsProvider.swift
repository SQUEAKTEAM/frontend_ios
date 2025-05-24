//
//  DailyStatsProvider.swift
//  LvL-up
//
//  Created by MyBook on 22.05.2025.
//

import Foundation

final class DailyStatsProvider: DailyStatsProviderProtocol {
    private let apiManager: APIManager
    
    init(apiManager: APIManager = APIManager.shared) {
        self.apiManager = apiManager
    }
    
    func fetchData() async throws -> DailyStats {
//        try? await Task.sleep(nanoseconds: 3_000_000_000)
//        return DailyStats(countSuccess: 5, countMiddle: 3, countFailure: 1, reward: 350)
        return try await apiManager.fetch("api/statistics/daily/")
    }
}
