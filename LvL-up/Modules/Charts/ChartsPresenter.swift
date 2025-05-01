//
//  ChartsPresenter.swift
//  LvL-up
//
//  Created by MyBook on 02.05.2025.
//

import Foundation

final class ChartsPresenter: ObservableObject {
    
    private let interactor: ChartsInteractorProtocol
    
    @Published var statistics: [Statistics] = []
    
    init(interactor: ChartsInteractorProtocol = ChartsInteractor()) {
        self.interactor = interactor
    }
    
    @MainActor
    func getData() async {
        statistics = await interactor.loadStatistics()
    }
}
