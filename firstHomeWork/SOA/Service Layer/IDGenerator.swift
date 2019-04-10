//
//  IDGenerator.swift
//  firstHomeWork
//
//  Created by Денис Сидоренко on 19/03/2019.
//  Copyright © 2019 Денис Сидоренко. All rights reserved.
//

import Foundation

class IDGenerator {
    static func generateMessageId() -> String {
        let string = "\(arc4random_uniform(UINT32_MAX)) +\(Date.timeIntervalSinceReferenceDate) +\(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString()
        return string!
    }
}
