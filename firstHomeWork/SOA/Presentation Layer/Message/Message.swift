//
//  Message.swift
//  firstHomeWork
//
//  Created by Денис Сидоренко on 19/03/2019.
//  Copyright © 2019 Денис Сидоренко. All rights reserved.
//

import Foundation


protocol MessageCellConfiguration: class {
    var text: String? { get set }
    var fromUser: String? { get set }
    var toUser: String? { get set }
}

class StoredMessage: MessageCellConfiguration {
    var text: String?
    var fromUser: String?
    var toUser: String?
    
    
    init(text: String, fromUser: String, toUser: String) {
        self.text = text
        self.fromUser = fromUser
        self.toUser = toUser
    }
    
}

class Message: Codable {
    var eventType: String
    var text: String
    var messageId: String
    
    init(text: String) {
        self.text = text
        self.eventType = "TextMessage"
        self.messageId = IDGenerator.generateMessageId()
    }
}
