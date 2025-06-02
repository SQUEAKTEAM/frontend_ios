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
    func fetchData() async throws -> [Category] {
        return try await apiManager.fetch("api/categories/")
//        return Array(Set(DailyTask.mockTasks.map({ $0.category })))
    }
    
    func create(category: String) async throws {
        let _: EmptyResponse = try await apiManager.post("api/category/", body: CategoryDTO(title: category))
    }
}

struct CategoryDTO: Codable {
    let title: String
}
