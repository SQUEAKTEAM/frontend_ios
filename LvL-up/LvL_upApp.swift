//
//  LvL_upApp.swift
//  LvL-up
//
//  Created by MyBook on 09.04.2025.
//

import SwiftUI

@main
struct LvL_upApp: App {
//    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            LoginView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environment(\.locale, Locale(identifier: "ru_RU"))
        }
    }
}
