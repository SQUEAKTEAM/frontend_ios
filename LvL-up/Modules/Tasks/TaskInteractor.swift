//
//  TaskInteractor.swift
//  LvL-up
//
//  Created by MyBook on 12.04.2025.
//

import Foundation

protocol TaskProviderProtocol {
    func fetchTasks(at date: Date?) async throws -> [DailyTask]
    func create(dailyTask: DailyTask) async throws
    func update(dailyTask: DailyTask) async throws
    func delete(_ id: Int) async throws
}

protocol TaskInteractorProtocol {
    func loadTasks() async -> [DailyTask]
    func loadTasks(at date: Date?) async -> [DailyTask]
    func update(_ dailyTask: DailyTask) async
    func create(_ dailyTask: DailyTask) async
    func delete(_ dailyTask: DailyTask) async
}

final class TaskInteractor: TaskInteractorProtocol {
    private let dataService: TaskProviderProtocol
    
    init(dataService: TaskProviderProtocol = TaskDataProvider()) {
        self.dataService = dataService
    }
    
    func loadTasks() async -> [DailyTask] {
        return (try? await dataService.fetchTasks(at: nil)) ?? []
    }
    
    func loadTasks(at date: Date?) async -> [DailyTask] {
        return (try? await dataService.fetchTasks(at: date)) ?? []
    }
    
    func update(_ dailyTask: DailyTask) async {
        do {
            try await dataService.update(dailyTask: dailyTask)
        } catch {
            print(error)
        }
    }
    
    func create(_ dailyTask: DailyTask) async {
        do {
            try await dataService.create(dailyTask: dailyTask)
        } catch {
            print(error)
        }
    }
    
    func delete(_ dailyTask: DailyTask) async {
        try? await dataService.delete(dailyTask.id)
    }
}
