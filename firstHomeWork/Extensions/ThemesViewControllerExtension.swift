//
//  ThemesViewControllerExtension.swift
//  firstHomeWork
//
//  Created by Денис Сидоренко on 06/03/2019.
//  Copyright © 2019 Денис Сидоренко. All rights reserved.
//

import Foundation
import UIKit


extension ThemesViewController {
    func initInterface() {
        
        lightThemeButton.backgroundColor = UIColor.lightGray
        durkThemeButton.backgroundColor = UIColor.lightGray
        champangneThemeButton.backgroundColor = UIColor.lightGray
        
        lightThemeButton.layer.cornerRadius = 5
        durkThemeButton.layer.cornerRadius = 5
        champangneThemeButton.layer.cornerRadius = 5
        
        lightThemeButton.setTitleColor(.yellow, for: .normal)
        durkThemeButton.setTitleColor(.yellow, for: .normal)
        champangneThemeButton.setTitleColor(.yellow, for: .normal)
        
        self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
    }
}
