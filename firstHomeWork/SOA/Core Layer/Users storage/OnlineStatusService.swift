//
//  OnlineStatusService.swift
//  firstHomeWork
//
//  Created by Денис Сидоренко on 10/04/2019.
//  Copyright © 2019 Денис Сидоренко. All rights reserved.
//

import Foundation

protocol UserStorage {
    func getOnlineUsers(users: [ConverastionCellConfiguration]) -> [ConverastionCellConfiguration]
    func getOflineUsers(users: [ConverastionCellConfiguration]) -> [ConverastionCellConfiguration]
}

class OnlineStatusService: UserStorage {
    
    func getOnlineUsers(users: [ConverastionCellConfiguration]) -> [ConverastionCellConfiguration] {
        let users = users.filter { (user) -> Bool in
            return user.online
        }
        return users
    }
    
    func getOflineUsers(users: [ConverastionCellConfiguration]) -> [ConverastionCellConfiguration] {
        let users = users.filter { (user) -> Bool in
            return !user.online
        }
        return users
    }
    
}
