//
//  LvLDataProvider.swift
//  LvL-up
//
//  Created by MyBook on 05.05.2025.
//

import Foundation
final class LvLDataProvider: LvLProviderProtocol {
    private let apiManager: APIManager
    
    init(apiManager: APIManager = APIManager.shared) {
        self.apiManager = apiManager
    }
    ///GET:  id: Int, countSuccess: Int, countMiddle: Int, countFailure: Int, title: String
    ///POST: user_id
    func fetchData() async throws -> LvL {
//        let user_id = 1
//        return try await apiManager.fetch("lvl/\(user_id)")
        return LvL.mock
    }
    
    func update(lvl: LvL) async throws {
//        let updatedTask: DailyTask = try await APIManager.shared.put("update_lvl/\(lvl.id)", body: lvl)
//        return lvl
    }
}
