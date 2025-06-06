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
            if oldValue != nil {
                if lvl?.currentLvl ?? 0 > oldValue?.currentLvl ?? 0 {
                    triggerConfetti.toggle()
                }
                Task(priority: .low) {
                    await update()
                }
            }
        }
    }
    
    @Published var triggerConfetti = false
    
    init(interactor: MainLvLInteractorProtocol = MainLvLInteractor()) {
        self.interactor = interactor
    }
    
    @MainActor
    func getData() async {
        lvl = await interactor.loadLvl()
        if lvl?.upperBoundExp == 0 {
            lvl = LvL.new
        }
    }
    
    @MainActor
    private func update() async {
        await interactor.update(lvl)
    }
    
    func updateLvLWith(_ exp: Float) {
        self.lvl?.currentExp += exp
    }
}
