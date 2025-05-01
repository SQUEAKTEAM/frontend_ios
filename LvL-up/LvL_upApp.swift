//
//  LvL_upApp.swift
//  LvL-up
//
//  Created by MyBook on 09.04.2025.
//

import SwiftUI
import ManagedSettings
import DeviceActivity
import FamilyControls

@main
struct LvL_upApp: App {
    let persistenceController = PersistenceController.shared
//    let center = DeviceActivityCenter()
//    let store = ManagedSettingsStore()
//    
//    init() {
//        requestAuthorization()
//        //setupMonitoring()
//    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
    
//    func requestAuthorization() {
//        Task {
//            do {
//                // Проверяем текущий статус авторизации
//                let status = AuthorizationCenter.shared.authorizationStatus
//                print("Current auth status: \(status)")
//                
//                // Если еще не авторизовано, запрашиваем доступ
//                if status != .approved {
//                    AuthorizationCenter.shared.requestAuthorization { result in
//                        switch result {
//                            case .success():
//                                break
//                            case .failure(let error):
//                            print("Error for Family Controls: \(error)")
//                        }
//                    }
//                }
//                
//                // Проверяем результат
//                if AuthorizationCenter.shared.authorizationStatus == .approved {
//                    print("Authorization successful")
//                    setupMonitoring()
//                } else {
//                    print("User denied authorization")
//                }
//            } catch {
//                print("Authorization failed: \(error.localizedDescription)")
//                // Показываем пользователю инструкцию
//                DispatchQueue.main.async {
//                    showAuthorizationInstructions()
//                }
//            }
//        }
//    }
//
//    private func showAuthorizationInstructions() {
//        // Реализуйте UI-алерт с инструкциями
//        print("Пожалуйста, разрешите доступ в настройках Screen Time")
//    }
//    
//    func setupMonitoring() {
//        // 1. Выбираем приложения для мониторинга
//        let apps = store.shield.applications
//        
//        // 2. Создаем расписание
//        let schedule = DeviceActivitySchedule(
//            intervalStart: DateComponents(hour: 8, minute: 0),
//            intervalEnd: DateComponents(hour: 22, minute: 0),
//            repeats: true
//        )
//        
//        // 3. Создаем события мониторинга
//        let events: [DeviceActivityEvent.Name: DeviceActivityEvent] = [
//            .monitoring: DeviceActivityEvent(
//                applications: apps!,
//                threshold: DateComponents(minute: 30)
//        )]
//        
//        // 4. Начинаем мониторинг
//        do {
//            try center.startMonitoring(
//                .dailyActivity,
//                during: schedule,
//                events: events
//            )
//            print("Monitoring started successfully")
//        } catch {
//            print("Failed to start monitoring: \(error)")
//        }
//    }
}
