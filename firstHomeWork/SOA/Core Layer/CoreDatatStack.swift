//
//  CoreDatatStack.swift
//  firstHomeWork
//
//  Created by Денис Сидоренко on 10/04/2019.
//  Copyright © 2019 Денис Сидоренко. All rights reserved.
//


import Foundation
import CoreData
import UIKit

class CoreDataStack {
    
    var storeUrl: URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsURL.appendingPathComponent("MyProfileStore.sqlite")
    }
    
    let dataModelName = "profileModel"
    let dataModelExtension = "momd"
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: self.dataModelName, withExtension: self.dataModelExtension)!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistantStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil,
                                               at: self.storeUrl,
                                               options: nil)
        } catch  {
            assert(false, "Error adding store: \(error)")
        }
        return coordinator
    }()
    
    lazy var masterContext: NSManagedObjectContext = {
        var masterContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType )
        masterContext.persistentStoreCoordinator = self.persistantStoreCoordinator
        masterContext.mergePolicy = NSOverwriteMergePolicy
        return masterContext
    }()
    
    lazy var mainContext : NSManagedObjectContext = {
        var mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainContext.parent = self.masterContext
        mainContext.mergePolicy = NSOverwriteMergePolicy
        return mainContext
    }()
    
    lazy var saveContext: NSManagedObjectContext = {
        var saveContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        saveContext.parent = self.mainContext
        saveContext.mergePolicy = NSOverwriteMergePolicy
        return saveContext
    }()
    
    typealias SaveCompoletion = () -> Void
    func performSave(with context: NSManagedObjectContext, completion: SaveCompoletion? = nil ) {
        context.perform {
            guard context.hasChanges else {
                completion?()
                return
            }
        }
        
        context.perform {
            do {
                try context.save()
            } catch {
                print("profile data save error: \(error)")
            }
            
            if let parentContext = context.parent {
                self.performSave(with: parentContext, completion: completion)
            } else {
                completion?()
            }
        }
    }
    
    // фетч резалт контроллер который возвращает все объекты выбранной сущности. такой контроллер использовать в conversationListViewController
    static func fetchedResultsController(entityName: String, keyForSort: String, sectionName: String) -> NSFetchedResultsController<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let sortDescriptor = NSSortDescriptor(key: keyForSort, ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: CoreDataManager.shared.cdStack.mainContext,
                                                                  sectionNameKeyPath: sectionName,
                                                                  cacheName: nil)
        return fetchedResultsController
    }
    
    // получить все сообщения для определенной беседы. такой контроллер использовать в ConversationViewController
    static func fetchedResultController2(entityName: String, keyForSort: String, conversationId: String) -> NSFetchedResultsController<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let sortDescriptor = NSSortDescriptor(key: keyForSort, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = NSPredicate(format: "conversationId == %@", conversationId)
        let fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                               managedObjectContext: CoreDataManager.shared.cdStack.mainContext,
                                                               sectionNameKeyPath: nil,
                                                               cacheName: nil)
        return fetchResultController
    }
    
}
