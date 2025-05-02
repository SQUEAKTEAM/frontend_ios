//
//  AchievementDataProvider.swift
//  LvL-up
//
//  Created by MyBook on 02.05.2025.
//

import Foundation

final class AchievementDataProvider: AchievementProviderProtocol {
    private let apiManager: APIManager
    
    init(apiManager: APIManager = APIManager.shared) {
        self.apiManager = apiManager
    }
    ///GET:  id: Int, title: String, currentXp: Int, upperBounds: Int, reward: Int, isCompleted: Bool
    ///POST: user_id
    func fetchData() async throws -> [Achievement] {
//        let user_id = 1
//        return try await apiManager.fetch("achievements/\(user_id)")
        return Achievement.mockAchievements
    }
}
