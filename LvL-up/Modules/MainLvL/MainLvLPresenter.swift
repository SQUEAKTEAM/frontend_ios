//
//  MainLvLPresenter.swift
//  LvL-up
//
//  Created by MyBook on 09.04.2025.
//

import Foundation

final class MainLvLPresenter: ObservableObject {
    @Published var lvl: LvL? = nil
    
    func getData() async {
        lvl = LvL(currentLvl: 3, current_exp: 55, upperBound_exp: 100)
    }
    
    init() {
        
    }
}
