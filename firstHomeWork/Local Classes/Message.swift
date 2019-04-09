//
//  Message.swift
//  firstHomeWork
//
//  Created by Денис Сидоренко on 19/03/2019.
//  Copyright © 2019 Денис Сидоренко. All rights reserved.
//

import Foundation

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
