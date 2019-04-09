//
//  DateManager.swift
//  firstHomeWork
//
//  Created by Денис Сидоренко on 24/02/2019.
//  Copyright © 2019 Денис Сидоренко. All rights reserved.
//

import Foundation

class DateManager {
    
    let dateFormater = DateFormatter()
    
    let dayNowComponent = Calendar.current.dateComponents([.day], from: Date())
    
    static var shared = DateManager()
    
    private init() { }
    
    func lastMessageDayIsCurrantDay(lastMessage carrentDay: DateComponents) -> String {
        return dayNowComponent == carrentDay ? "HH:mm" : "dd MMM"
    }
    
}
