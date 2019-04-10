//
//  ThemeManager.swift
//  firstHomeWork
//
//  Created by Денис Сидоренко on 06/03/2019.
//  Copyright © 2019 Денис Сидоренко. All rights reserved.
//

import Foundation
import UIKit


let SelectedThemeKey = "SelectedTheme"

class ThemeManager {
    
    static func currentTheme() -> Theme {
        if let storedTheme = (UserDefaults.standard.value(forKey: SelectedThemeKey) as AnyObject).integerValue {
            return Theme(rawValue: storedTheme)!
        } else {
            return .shampan
        }
    }
    
    static func applyTheme(theme: Theme) {
        
        UserDefaults.standard.setValue(theme.rawValue, forKey: SelectedThemeKey)
        UserDefaults.standard.synchronize()
        
        let sharedApplication = UIApplication.shared
        sharedApplication.delegate?.window??.tintColor = theme.mainColor
        
        UINavigationBar.appearance().barStyle = theme.barStyle
        UINavigationBar.appearance().tintColor = theme.secondaryColor
        UINavigationBar.appearance().backgroundColor = theme.backgroundColor
        UITabBar.appearance().barStyle = theme.barStyle
    }
}
