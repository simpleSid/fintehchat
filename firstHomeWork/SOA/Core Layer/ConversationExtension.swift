//
//  ConversationExtension.swift
//  firstHomeWork
//
//  Created by Денис Сидоренко on 11/04/2019.
//  Copyright © 2019 Денис Сидоренко. All rights reserved.
//

import Foundation
import CoreData


extension Conversation {
    
    // вставить новую беседу
    static func insertConversation(in context: NSManagedObjectContext) -> Conversation? {
        var conversation: Conversation? = nil
        context.performAndWait {
            if let currentConversation = NSEntityDescription.insertNewObject(forEntityName: "Conversation", into: context) as? Conversation {
                conversation = currentConversation
            }
        }
        return conversation
    }
}
