//
//  MyProfile.swift
//  firstHomeWork
//
//  Created by Денис Сидоренко on 26/03/2019.
//  Copyright © 2019 Денис Сидоренко. All rights reserved.
//

import Foundation
import UIKit

class MyProfile {
    var name: String
    var description: String
    var image: UIImage
    
    init(name: String?, description: String?, image: UIImage?) {
        self.name = name ?? "name"
        self.description = description ?? "description"
        self.image = image ?? #imageLiteral(resourceName: "placeholder-user")
    }
}
