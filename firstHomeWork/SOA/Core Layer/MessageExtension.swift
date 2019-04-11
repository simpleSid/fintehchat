//
//  MessageExtension.swift
//  firstHomeWork
//
//  Created by Денис Сидоренко on 11/04/2019.
//  Copyright © 2019 Денис Сидоренко. All rights reserved.
//

import Foundation
import CoreData

extension Message {
    
    // вставить новое сообщение
    static func insertMessage(in context: NSManagedObjectContext) -> Message? {
        var message: Message? = nil
        context.performAndWait {
            if let currentMessage = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as? Message {
                message = currentMessage
            }
        }
        return message
    }
    
    
    
    // получить сообщения из определенной беседы по conversationId
    static func fetchMessageWith(id: String) -> NSFetchRequest<Message> {
        let request: NSFetchRequest<Message> = Message.fetchRequest()
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "conversationId == %@", id)
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        return request
    }
    
    // получить последнее сообщение в определенной беседе
    static func findLastMessage(conversation id: String, in context: NSManagedObjectContext) -> Message? {
        var message: Message?
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message") as! NSFetchRequest<Message>
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = NSPredicate(format: "conversationId == %@", id)
        context.performAndWait {
            do {
                let results = try context.fetch(fetchRequest)
                if let foundMessage = results.first {
                    message = foundMessage
                }
            } catch let error {
                print(error)
            }
        }
        return message
    }
}
