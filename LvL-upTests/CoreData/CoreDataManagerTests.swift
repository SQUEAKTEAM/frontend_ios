//
//  CoreDataManagerTests.swift
//  LvL-upTests
//
//  Created by MyBook on 11.04.2025.
//

import XCTest
import CoreData
@testable import LvL_up

class CoreDataManagerTests: XCTestCase {
    
    var coreDataManager: CoreDataManager<LvLEntity>!
    var testStack: TestCoreDataManagerStack!
    
    override func setUp() {
        super.setUp()
        testStack = TestCoreDataManagerStack()
        coreDataManager = CoreDataManager<LvLEntity>(context: testStack.persistentContainer.viewContext)
    }
    
    override func tearDown() {
        coreDataManager = nil
        testStack = nil
        super.tearDown()
    }
    
    func testCreateEntity() {
        let entity = coreDataManager.create()
        XCTAssertNotNil(entity)
        XCTAssertFalse(entity.isDeleted)
    }
    
    func testFetchAllEmpty() {
        // When
        let results = coreDataManager.fetchAll()
        
        // Then
        XCTAssertTrue(results.isEmpty)
    }
    
    func testFetchAllWithData() {
        // Given
        let entity1 = coreDataManager.create()
        entity1.currentLvl = 1
        let entity2 = coreDataManager.create()
        entity2.currentLvl = 2
        
        // When
        let results = coreDataManager.fetchAll()
        
        // Then
        XCTAssertEqual(results.count, 2)
        
        // Сортируем результаты, так как порядок не гарантирован
        let sortedResults = results.sorted { $0.currentLvl < $1.currentLvl }
        XCTAssertEqual(sortedResults.map { $0.currentLvl }, [1, 2])
    }
    
    func testFetchAllWithPredicate() {
        // Given
        let entity1 = coreDataManager.create()
        entity1.currentLvl = 1
        let entity2 = coreDataManager.create()
        entity2.currentLvl = 2
        
        let predicate = NSPredicate(format: "currentLvl == %d", 2)
        
        // When
        let results = coreDataManager.fetchAll(predicate: predicate)
        
        // Then
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.currentLvl, 2)
    }
    
    func testUpdate() {
        // Given
        let entity = coreDataManager.create()
        entity.currentLvl = 1
        
        // When
        var updatedValue: Int32 = 0
        coreDataManager.update {
            entity.currentLvl = 5
            updatedValue = entity.currentLvl
        }
        
        // Then
        XCTAssertEqual(updatedValue, 5)
        XCTAssertEqual(entity.currentLvl, 5)
    }
    
    func testDelete() {
        // Given
        let entity = coreDataManager.create()
        
        // When
        coreDataManager.delete(entity)
        
        // Then
        let results = coreDataManager.fetchAll()
        XCTAssertTrue(results.isEmpty)
    }
}

// MARK: - Test CoreData Stack

class TestCoreDataManagerStack {
    lazy var persistentContainer: NSPersistentContainer = {
        // Создаем описание сущности в памяти
        let managedObjectModel: NSManagedObjectModel = {
            let model = NSManagedObjectModel()
            
            // Создаем сущность LvLEntity
            let entity = NSEntityDescription()
            entity.name = "LvLEntity"
            entity.managedObjectClassName = "LvLEntity"
            
            // Добавляем атрибуты
            let currentLvl = NSAttributeDescription()
            currentLvl.name = "currentLvl"
            currentLvl.attributeType = .integer32AttributeType
            currentLvl.isOptional = false
            
            let upperBounds = NSAttributeDescription()
            upperBounds.name = "upperBounds"
            upperBounds.attributeType = .floatAttributeType
            upperBounds.isOptional = false
            
            let currentXp = NSAttributeDescription()
            currentXp.name = "currentXp"
            currentXp.attributeType = .floatAttributeType
            currentXp.isOptional = false
            
            entity.properties = [currentLvl, upperBounds, currentXp]
            model.entities = [entity]
            
            return model
        }()
        
        let container = NSPersistentContainer(name: "TestContainer", managedObjectModel: managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
}

class TestTaskCoreDataManagerStack {
    lazy var persistentContainer: NSPersistentContainer = {
        // Создаем описание сущности в памяти
        let managedObjectModel: NSManagedObjectModel = {
            let model = NSManagedObjectModel()
            
            // Создаем сущность DailyTaskEntity (или LvLEntity, если нужно сохранить старое имя)
            let entity = NSEntityDescription()
            entity.name = "DailyTaskEntity" // Или "LvLEntity", если нужно
            entity.managedObjectClassName = "DailyTaskEntity"
            
            // Создаем атрибуты согласно скриншоту
            let id = NSAttributeDescription()
            id.name = "id"
            id.attributeType = .UUIDAttributeType
            id.isOptional = false
            
            let checkPoint = NSAttributeDescription()
            checkPoint.name = "checkPoint"
            checkPoint.attributeType = .integer16AttributeType
            checkPoint.isOptional = false
            
            let checkPoints = NSAttributeDescription()
            checkPoints.name = "checkPoints"
            checkPoints.attributeType = .integer16AttributeType
            checkPoints.isOptional = false
            
            let currentProgress = NSAttributeDescription()
            currentProgress.name = "currentProgress"
            currentProgress.attributeType = .floatAttributeType
            currentProgress.isOptional = false
            
            let img = NSAttributeDescription()
            img.name = "img"
            img.attributeType = .stringAttributeType
            img.isOptional = false
            
            let isCompleted = NSAttributeDescription()
            isCompleted.name = "isCompleted"
            isCompleted.attributeType = .booleanAttributeType
            isCompleted.isOptional = false
            
            let reward = NSAttributeDescription()
            reward.name = "reward"
            reward.attributeType = .integer16AttributeType
            reward.isOptional = false
            
            let title = NSAttributeDescription()
            title.name = "title"
            title.attributeType = .stringAttributeType
            title.isOptional = false
            
            let upperBounds = NSAttributeDescription()
            upperBounds.name = "upperBounds"
            upperBounds.attributeType = .floatAttributeType
            upperBounds.isOptional = false
            
            // Добавляем все атрибуты в сущность
            entity.properties = [
                id,
                checkPoint,
                checkPoints,
                currentProgress,
                img,
                isCompleted,
                reward,
                title,
                upperBounds
            ]
            
            model.entities = [entity]
            
            return model
        }()
        
        let container = NSPersistentContainer(name: "TestContainer", managedObjectModel: managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
}
