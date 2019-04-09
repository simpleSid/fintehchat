//
//  DialogTableViewCellOutside.swift
//  firstHomeWork
//
//  Created by Денис Сидоренко on 24/02/2019.
//  Copyright © 2019 Денис Сидоренко. All rights reserved.
//

import UIKit

class DialogTableViewCell: UITableViewCell {
   
    @IBOutlet weak var message: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //работа с темой
        self.backgroundColor = ThemeManager.currentTheme().backgroundColor
        self.message.textColor = ThemeManager.currentTheme().titleTextColor
    }
    
}
