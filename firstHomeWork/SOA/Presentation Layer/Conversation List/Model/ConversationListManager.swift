//
//  ConversationListManager.swift
//  firstHomeWork
//
//  Created by Денис Сидоренко on 24/02/2019.
//  Copyright © 2019 Денис Сидоренко. All rights reserved.
//

import UIKit

class ConversationListManager {
    
    static var nameOfFont = ""
    
    static func changeMessagefont(cell: ConversationTableViewCell, message: String?) -> ConversationTableViewCell {

        if message == nil {
            nameOfFont = "Chalkboard SE"
            cell.lastMessageLabel.text = "No messages yet"
            cell.lastMessageLabel.font = UIFont(name: nameOfFont, size: 17)
        } else {
            nameOfFont = "Apple SD Gothic Neo"
            cell.lastMessageLabel.font = UIFont(name: nameOfFont, size: 17)
            cell.lastMessageLabel.text = message
        }
        return cell
    }
    
    
    static func changeUnreadMessageStyle(cell: ConversationTableViewCell, hasUnreadMessages: Bool) -> ConversationTableViewCell {
        if hasUnreadMessages {
            cell.lastMessageLabel.font = UIFont(name: nameOfFont + " Bold", size: 17)
        } else {
            cell.lastMessageLabel.font = UIFont(name: nameOfFont, size: 17)
        }
        return cell
    }
    
}
