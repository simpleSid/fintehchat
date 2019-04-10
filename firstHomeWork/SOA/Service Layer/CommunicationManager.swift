//
//  CommunicationManager.swift
//  firstHomeWork
//
//  Created by Денис Сидоренко on 23/03/2019.
//  Copyright © 2019 Денис Сидоренко. All rights reserved.
//

import Foundation

protocol CommunicatorDelegate : class {
    //discovering
    func didFoundUser(userID: String, username: String?)
    func didLostUser(userID: String)
    
    //errors
    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error: Error)
    
    //messages
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
    
}

class CommunicationManager: CommunicatorDelegate {
    
    var communicator: MultipeerCommunicator
    var delegate: CommunicatorDelegate?
    
    init() {
        self.communicator = MultipeerCommunicator()
        communicator.delegate = self 
    }
    
    func didFoundUser(userID: String, username: String?) {
        delegate?.didFoundUser(userID: userID, username: username)
    }
    
    func didLostUser(userID: String) {
        delegate?.didLostUser(userID: userID)
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        delegate?.failedToStartBrowsingForUsers(error: error)
    }
    
    func failedToStartAdvertising(error: Error) {
        delegate?.failedToStartAdvertising(error: error)
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        delegate?.didReceiveMessage(text: text, fromUser: fromUser, toUser: toUser)
    }
    
    
}

