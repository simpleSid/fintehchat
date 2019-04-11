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
    
    func getCurrentProfile() -> MyProfile {
        let context = self.cdStack.mainContext
        let profile = Profile.findOrInsertProfileData(in: context)
//        self.cdStack.performSave(with: context, completion: nil)
        print(profile?.name ?? "нету имени", profile?.about ?? "нету описания")
        return MyProfile(name: profile?.name,
                         description: profile?.about,
                         image: UIImage(data: (profile?.image) ?? #imageLiteral(resourceName: "placeholder-user").pngData()!))
    }
    
    func getLastMessageFrom(conversation id: String) -> Message? {
        let context = self.cdStack.mainContext
        let message = Message.findLastMessage(conversation: id, in: context)
        return message
    }
    
    // работа с беседами сохранение беседы
    func saveConversation(new conversation: MyConversation, completion: (() ->())?) {
        let context = self.cdStack.saveContext
        guard let newConversation = Conversation.insertConversation(in: context) else { return }
        context.performAndWait {
            newConversation.userId = conversation.userId
            newConversation.isOnline = conversation.isOnline
            newConversation.conversationId = conversation.conversationId
            
            print("\(conversation.userId), \(conversation.isOnline), \(conversation.conversationId)")
            print("\(newConversation.userId), \(newConversation.isOnline), \(newConversation.conversationId)")
            
            self.cdStack.performSave(with: context, completion: completion)
        }
    }
    
    // работа с сообщениями сохранение сообщений
    func saveMessage(new message: MyMessage, completion: (() ->())?) {
        let context = self.cdStack.saveContext
        guard let newMessage = Message.insertMessage(in: context) else { return }
        context.performAndWait {
            newMessage.conversationId  = message.conversationId
            newMessage.messageId = message.messageId
            newMessage.receiverId = message.receiverId
            newMessage.senderId = message.senderId
            newMessage.text = message.text
            newMessage.timestamp = message.timestamp
        }
        self.cdStack.performSave(with: context, completion: completion)
    }
}


class MyConversation {
    
    var userId: String
    var conversationId: String
    var isOnline: Bool
    
    init(userId: String?, conversationId: String?, isOnline: Bool?) {
        self.userId = userId ?? "some name"
        self.conversationId = conversationId ?? "some conversationId"
        self.isOnline = isOnline ?? false
    }
    
}

class MyMessage {
    var conversationId: String
    var messageId: String
    var receiverId: String
    var senderId: String
    var text: String
    var timestamp: Date
    
    init(conversationId: String?, messageId: String?, receiverId: String?, senderId: String?, text: String?) {
        self.conversationId = conversationId ?? "some Value"
        self.messageId = messageId ?? "some Value"
        self.receiverId = receiverId ?? "some Value"
        self.senderId = senderId ?? "some Value"
        self.text = text ?? "some Value"
        self.timestamp = Date()
    }
}
