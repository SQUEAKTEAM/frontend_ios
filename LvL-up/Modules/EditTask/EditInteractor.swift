//
//  EditInteractor.swift
//  LvL-up
//
//  Created by MyBook on 04.05.2025.
//

import Foundation

protocol CategoryProviderProtocol {
    func fetchData() async throws -> [String]
}

protocol EditInteractorProtocol {
    func loadCategory() async -> [String]
}

final class EditInteractor: EditInteractorProtocol {
    
    private let dataService: CategoryProviderProtocol
    
    init(dataService: CategoryProviderProtocol = CategoryDataProvider()) {
        self.dataService = dataService
    }
    
    func loadCategory() async -> [String] {
        return (try? await dataService.fetchData()) ?? []
    }
}
