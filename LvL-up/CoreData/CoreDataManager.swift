//
//  CoreDataManager.swift
//  LvL-up
//
//  Created by MyBook on 11.04.2025.
//

import CoreData
import SwiftUI

final class CoreDataManager<T: NSManagedObject> {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }
    
    // CREATE
    func create() -> T {
        let entity = T(context: context)
        save()
        return entity
    }
    
    // READ
    func fetchAll(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> [T] {
        let request = NSFetchRequest<T>(entityName: String(describing: T.self))
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        
        do {
            return try context.fetch(request)
        } catch {
            print("Fetch error: \(error.localizedDescription)")
            return []
        }
    }
    
    // UPDATE
    func update(_ block: @escaping () -> Void) {
        block()
        save()
    }
    
    // DELETE
    func delete(_ entity: T) {
        context.delete(entity)
        save()
    }
    
    // SAVE
    private func save() {
        do {
            try context.save()
        } catch {
            print("Save error: \(error.localizedDescription)")
        }
    }
}
