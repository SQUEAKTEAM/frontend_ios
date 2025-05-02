//
//  AchievementPresenter.swift
//  LvL-up
//
//  Created by MyBook on 02.05.2025.
//

import Foundation

final class AchievementPresenter: ObservableObject {
    
    private let interactor: AchievementInteractorProtocol
    
    @Published var achievements: [Achievement] = []
    
    init(interactor: AchievementInteractorProtocol = AchievementInteractor()) {
        self.interactor = interactor
    }
    
    @MainActor
    func getData() async {
        achievements = await interactor.loadAchievements().sorted { !$0.isCompleted && $1.isCompleted }
    }
}
