//
//  EditInteractor.swift
//  LvL-up
//
//  Created by MyBook on 04.05.2025.
//

import Foundation

protocol CategoryProviderProtocol {
    func fetchData() async throws -> [Category]
    func create(category: String) async throws
}

protocol EditInteractorProtocol {
    func loadCategory() async -> [Category]
    func create(category: String) async
}

final class EditInteractor: EditInteractorProtocol {
    
    private let dataService: CategoryProviderProtocol
    
    init(dataService: CategoryProviderProtocol = CategoryDataProvider()) {
        self.dataService = dataService
    }
    
    func loadCategory() async -> [Category] {
        return (try? await dataService.fetchData()) ?? []
    }
    
    func create(category: String) async {
        try? await dataService.create(category: category)
    }
}
