//
//  TestView.swift
//  LvL-up
//
//  Created by MyBook on 16.04.2025.
//

import SwiftUI
import ManagedSettings
import DeviceActivity
import FamilyControls

// Расширение для идентификации событий
extension DeviceActivityEvent.Name {
    static let monitoring = Self("monitoring")
}

// Расширение для идентификации периодов активности
extension DeviceActivityName {
    static let dailyActivity = Self("dailyActivity")
}

// View для выбора приложений
struct AppSelectorView: View {
    @State private var model = FamilyActivitySelection()
    
    var body: some View {
        FamilyActivityPicker(selection: $model)
            .onChange(of: model) { newSelection in
                let store = ManagedSettingsStore()
                store.shield.applications = newSelection.applicationTokens
            }
    }
}

// Пример ContentView
struct TestView: View {
    var body: some View {
        VStack {
            Text("Screen Time Monitoring")
                .font(.title)
            
            AppSelectorView()
                .frame(height: 400)
            
            Button("Start Monitoring") {
                // Можно добавить дополнительную логику запуска
            }
            .padding()
        }
    }
}
