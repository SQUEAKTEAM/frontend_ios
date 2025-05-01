//
//  ChartsDataProvider.swift
//  LvL-up
//
//  Created by MyBook on 02.05.2025.
//

import Foundation

final class ChartsDataProvider: ChartsProviderProtocol {
    private let apiManager: APIManager
    
    init(apiManager: APIManager = APIManager()) {
        self.apiManager = apiManager
    }
    
    func fetchData() async -> [Statistics] {
        return Statistics.mockStatistics
    }
}
