//
//  LogManager.swift
//  firstHomeWork
//
//  Created by Денис Сидоренко on 10/02/2019.
//  Copyright © 2019 Денис Сидоренко. All rights reserved.
//

import Foundation

class LogManager {
    
    var isLoggedState: Bool
    var previoslyState: String
    
    func printCurrentState(text message: String, isLogged: Bool) {
        guard isLogged else { return }
        print(message)
    }
    
    init() {
        isLoggedState = true
        previoslyState = ""
    }
    
    init(isLogged: Bool) {
        self.isLoggedState = isLogged
        previoslyState = ""
    }
}
