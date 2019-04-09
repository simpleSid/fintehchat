//
//  UsersMessages.swift
//  firstHomeWork
//
//  Created by Денис Сидоренко on 25/02/2019.
//  Copyright © 2019 Денис Сидоренко. All rights reserved.
//

import Foundation

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

//class StoredMessages {
//    var messages = [StoredMessages]()
//}