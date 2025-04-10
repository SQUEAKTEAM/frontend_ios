//
//  LvL_upApp.swift
//  LvL-up
//
//  Created by MyBook on 09.04.2025.
//

import SwiftUI

@main
struct LvL_upApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            TasksView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
