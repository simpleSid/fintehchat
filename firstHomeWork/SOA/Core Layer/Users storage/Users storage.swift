//
//  Users storage.swift
//  firstHomeWork
//
//  Created by Денис Сидоренко on 10/04/2019.
//  Copyright © 2019 Денис Сидоренко. All rights reserved.
//

import Foundation

protocol UsersStorage {
    var users: [ConverastionCellConfiguration] {get set}
}

class Userss: UsersStorage {
    var users: [ConverastionCellConfiguration] = [ConverastionCellConfiguration]()
}
