//
//  ChartsDataProvider.swift
//  LvL-up
//
//  Created by MyBook on 02.05.2025.
//

import Foundation

final class ChartsDataProvider: ChartsProviderProtocol {
    private let apiManager: APIManager
    
    init(apiManager: APIManager = APIManager.shared) {
        self.apiManager = apiManager
    }
    ///GET:  id: Int, countSuccess: Int, countMiddle: Int, countFailure: Int, title: String
    ///POST: user_id
    func fetchData() async throws -> [Statistics] {
        return try await apiManager.fetch("api/statistics/")
//        return Statistics.mockStatistics
    }
}
