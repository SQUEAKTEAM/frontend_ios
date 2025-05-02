//
//  AchievementInteractor.swift
//  LvL-up
//
//  Created by MyBook on 02.05.2025.
//

import Foundation

protocol AchievementProviderProtocol {
    func fetchData() async throws -> [Achievement]
}

protocol AchievementInteractorProtocol {
    func loadAchievements() async -> [Achievement]
}

final class AchievementInteractor: AchievementInteractorProtocol {
    
    private let dataService: AchievementProviderProtocol
    
    init(dataService: AchievementProviderProtocol = AchievementDataProvider()) {
        self.dataService = dataService
    }
    
    func loadAchievements() async -> [Achievement] {
        return (try? await dataService.fetchData()) ?? []
    }
}
