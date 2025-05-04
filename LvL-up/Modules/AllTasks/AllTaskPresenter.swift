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
    
    func editTask(_ task: DailyTask) -> AnyView {
        router.navigateToEditTask(for: task) { [weak self] dailyTask in
            guard let self = self else { return }
            
            Task {
                guard 
                    let newTask = await self.interactor.update(dailyTask),
                    let index = self.tasks.firstIndex(where: { $0.id == newTask.id }) else { return }
                DispatchQueue.main.async {
                    self.tasks[index] = dailyTask
                }
            }
        }
    }
}
