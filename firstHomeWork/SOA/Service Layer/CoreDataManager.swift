//
//  CoreDataManager.swift
//  firstHomeWork
//
//  Created by Денис Сидоренко on 10/04/2019.
//  Copyright © 2019 Денис Сидоренко. All rights reserved.
//

import Foundation
import CoreData
import UIKit

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
