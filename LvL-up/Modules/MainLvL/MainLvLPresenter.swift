//
//  MainLvLPresenter.swift
//  LvL-up
//
//  Created by MyBook on 09.04.2025.
//

import Foundation


final class MainLvLPresenter: ObservableObject {
    
    private let interactor: MainLvLInteractorProtocol
    
    @Published var lvl: LvL? = nil {
        didSet {
            update()
        }
    }
    
    init(interactor: MainLvLInteractorProtocol = MainLvLInteractor()) {
        self.interactor = interactor
    }
    
    @MainActor
    func getData() async {
        lvl = interactor.loadLvl()
    }
    
    private func update() {
        interactor.update(lvl)
    }
}
