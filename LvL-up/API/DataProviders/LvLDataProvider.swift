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
        let lvl: LvL = try await apiManager.fetch("api/lvl/")
        return lvl
//        return LvL.mock
    }
    
    func update(lvl: LvL) async throws {
        let _: EmptyResponse = try await APIManager.shared.put("api/lvl/", body: lvl)
//        return lvl
    }
}
