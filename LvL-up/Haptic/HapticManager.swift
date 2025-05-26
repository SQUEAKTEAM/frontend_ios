//
//  HapticManager.swift
//  LvL-up
//
//  Created by MyBook on 25.05.2025.
//

import SwiftUI

actor HapticManager {
    
    @MainActor static private let generator = UINotificationFeedbackGenerator()
    
    @MainActor static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
}
