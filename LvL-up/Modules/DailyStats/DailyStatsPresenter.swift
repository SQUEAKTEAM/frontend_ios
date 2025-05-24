//
//  DailyStatsPresenter.swift
//  LvL-up
//
//  Created by MyBook on 22.05.2025.
//

import Foundation

final class DailyStatsPresenter: ObservableObject {
    
    @Published var stats: DailyStats? = nil
    
    
    private let interactor: DailyStatsInteractorProtocol
    
    init(interactor: DailyStatsInteractorProtocol = DailyStatsInteractor()) {
        self.interactor = interactor
    }
    
    @MainActor
    func getData() async {
        stats = await interactor.loadDailyStats()
    }
}
