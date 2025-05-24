//
//  AlertHanding.swift
//  LvL-up
//
//  Created by MyBook on 16.05.2025.
//

import Foundation

protocol AlertHandling: ObservableObject {
    var alertStatus: AlertStatus? { get set }
}

extension AlertHandling {
    func showError(_ status: AlertStatus) {
        alertStatus = status
    }
}
