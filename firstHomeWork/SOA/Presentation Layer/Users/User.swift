//
//  Users.swift
//  firstHomeWork
//
//  Created by Денис Сидоренко on 22/02/2019.
//  Copyright © 2019 Денис Сидоренко. All rights reserved.
//

import Foundation

protocol ConverastionCellConfiguration : class {
    var name: String? { get set }
    var message: String? { get set }
    var date: Date? { get set }
    var online: Bool { get set }
    var hasUnreadMessages: Bool { get set }
}

class User: ConverastionCellConfiguration {
    
    var name: String?
    var message: String?
    var date: Date?
    var online: Bool
    var hasUnreadMessages: Bool
    var isReuse: Bool
    var storedMessages = [StoredMessage]()
    
    init(name: String?, message: String?, date: Date?, online: Bool, hasUnreadMessage: Bool) {
        self.name = name
        self.message = message
        self.date = date
        self.online = online
        self.hasUnreadMessages = hasUnreadMessage
        self.isReuse = false 
    }
    
}




class Users {
    
    static var users = [User]()
    
    static var onlineUsers: [User] {
        get {
            let users = self.users.filter { (user) -> Bool in
                return user.online
            }
            return users
        }
    }
    
    static var oflineUsers : [User] {
        get {
            let users = self.users.filter { (user) -> Bool in
                return !user.online
            }
            return users
        }
    }
}
