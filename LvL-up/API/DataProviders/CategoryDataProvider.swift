//
//  CategoryDataProvider.swift
//  LvL-up
//
//  Created by MyBook on 04.05.2025.
//

import Foundation

final class CategoryDataProvider: CategoryProviderProtocol {
    private let apiManager: APIManager
    
    init(apiManager: APIManager = APIManager.shared) {
        self.apiManager = apiManager
    }
    ///GET:  id: Int, countSuccess: Int, countMiddle: Int, countFailure: Int, title: String
    ///POST: user_id
    func fetchData() async throws -> [String] {
//        let user_id = 1
//        return try await apiManager.fetch("categories/\(user_id)")
        return Array(Set(DailyTask.mockTasks.map({ $0.category })))
    }
}
