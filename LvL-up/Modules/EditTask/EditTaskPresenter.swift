//
//  EditTaskPresenter.swift
//  LvL-up
//
//  Created by MyBook on 04.05.2025.
//

import Foundation

final class EditTaskPresenter: ObservableObject {
    @Published var task: DailyTask
    @Published var categories: [Category] = []
    
    private let interactor: EditInteractorProtocol
    
    init(task: DailyTask, interactor: EditInteractorProtocol = EditInteractor()) {
        self.interactor = interactor
        self.task = task
    }
    
    @MainActor
    func getCategories() async {
        categories = await interactor.loadCategory()
        if task.category.id == 0 && !categories.isEmpty {
            task.category = categories.first!
        }
    }
    
    func createCategory(title: String) async {
        await interactor.create(category: title)
        await getCategories()
    }
}
