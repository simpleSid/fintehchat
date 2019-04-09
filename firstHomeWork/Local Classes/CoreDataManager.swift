//
//  CoreDataManager.swift
//  firstHomeWork
//
//  Created by Денис Сидоренко on 25/03/2019.
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
    
}


extension Profile {
    
    
    static func insertProfileData(in context: NSManagedObjectContext) -> Profile? {
        var profile: Profile? = nil
        context.perform {
            if let currentProfile = NSEntityDescription.insertNewObject(forEntityName: "Profile", into: context) as? Profile {
                profile = currentProfile
            }
        }
        return profile
    }
    
    static func fetchRequestGetProfileData(model: NSManagedObjectModel) -> NSFetchRequest<Profile>? {
        let templateName = "getProfileData"
        guard let fetchRequest = model.fetchRequestTemplate(forName: templateName) as? NSFetchRequest<Profile> else {
            assert(false, "No template with name \(templateName)")
            return nil
        }
        return fetchRequest
    }
    
    static func findOrInsertProfileData(in context: NSManagedObjectContext) -> Profile? {
        
//        let stack = CoreDataStack()
        
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print("Model is not available in context!")
            return nil
        }
        var profile: Profile?
        guard let fetchRequest = Profile.fetchRequestGetProfileData(model: model) else {
            return nil
        }
        
        context.performAndWait {
            do {
                
                let results = try context.fetch(fetchRequest)
//                assert(results.count < 2, "Multiple profiles found!")
                if let foundProfile = results.first {
                    profile = foundProfile
                }
            } catch {
                print("failed to fetch Profile: \(error)")
            }
            
        }
        
        if profile == nil {
            profile = Profile.insertProfileData(in: context)
        }
        
        return profile
    }

}



class CoreDataManager {
    
    static var shared = CoreDataManager()
    
    var cdStack : CoreDataStack
    
    private init() {
        cdStack = CoreDataStack()
    }
    
    func saveCurrentProfile(myProfile: MyProfile, completion: (() ->())?) {
        let context = self.cdStack.saveContext
        let profile = Profile.findOrInsertProfileData(in: context)
        context.perform {
            profile?.name = myProfile.name
            profile?.about = myProfile.description
            profile?.image = myProfile.image.pngData()
            self.cdStack.performSave(with: context, completion: completion)
        }
    }
    
    public func getCurrentProfile() -> MyProfile {
        let context = self.cdStack.mainContext
        let profile = Profile.findOrInsertProfileData(in: context)
        self.cdStack.performSave(with: context, completion: nil)
        print(profile?.name ?? "нету имени", profile?.about ?? "нету описания")
        return MyProfile(name: profile?.name,
                         description: profile?.about,
                         image: UIImage(data: (profile?.image) ?? #imageLiteral(resourceName: "placeholder-user").pngData()!))
    }
    
}


