//
//  AllTaskPresenter.swift
//  LvL-up
//
//  Created by MyBook on 16.04.2025.
//

import Foundation
import SwiftUI

final class AllTaskPresenter: ObservableObject {
    
    private let interactor: TaskInteractorProtocol
    private let router: AllTaskRouterProtocol
    
    @Binding var tasks: [DailyTask]
    
    init(interactor: TaskInteractorProtocol = TaskInteractor(), router: AllTaskRouterProtocol = AllTaskRouter(), tasks: Binding<[DailyTask]>) {
        self.interactor = interactor
        self.router = router
        self._tasks = tasks
    }
    
    func getTasks(_ isArchived: Bool) -> [DailyTask] {
        if isArchived {
            return tasks.filter({ $0.isArchived })
        } else {
            return tasks.filter({ !$0.isArchived })
        }
    }
    
    func archiveTask(_ task: DailyTask) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        tasks[index].isArchived = !tasks[index].isArchived
        Task {
            await interactor.update(task)
        }
    }
    
    func deleteTask(_ task: DailyTask) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        let task = tasks.remove(at: index)
        Task {
            await interactor.delete(task)
        }
    }
    
    func editTask(_ task: DailyTask) -> AnyView {
        return router.navigateToEditTask(for: task) { [weak self] dailyTask in
            guard let self = self else { return }
            
            Task { @MainActor in
                await self.interactor.update(dailyTask)
                guard
                    let index = self.tasks.firstIndex(where: { $0.id == dailyTask.id }) else { return }
//                DispatchQueue.main.async {
                    self.tasks[index] = dailyTask
//                }
            }
        }
    }
}
