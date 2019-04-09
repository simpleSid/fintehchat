//
//  ConversationCellConfigurationProtocol.swift
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
