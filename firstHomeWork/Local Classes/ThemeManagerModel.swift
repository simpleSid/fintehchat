//
//  ThemeManager.swift
//  firstHomeWork
//
//  Created by Денис Сидоренко on 05/03/2019.
//  Copyright © 2019 Денис Сидоренко. All rights reserved.
//

import UIKit
import Foundation


enum Theme: Int {
    
    case ligth, dark, shampan
    
    var mainColor: UIColor {   //
        switch self {
        case .ligth:
            return UIColor.black
        case .dark:
            return UIColor.white
        case .shampan:
            return UIColor.blue
        }
    }
    
    var barStyle: UIBarStyle {
        switch self {
        case .ligth:
            return .default
        case .dark:
            return .black
        case .shampan:
            return .black
        }
    }
    
    var backgroundColor: UIColor {  //цвет фона
        switch self {
        case .ligth:
            return UIColor.white
        case .dark:
            return UIColor.black
        case .shampan:
            return UIColor.yellow
        }
    }
    
    var secondaryColor: UIColor {  //цвет кнопок навигации
        switch self {
        case .ligth:
            return UIColor.black
        case .dark:
            return UIColor.white
        case .shampan:
            return UIColor.white
            
        }
    }
    
    var titleTextColor: UIColor {
        switch self {
        case .ligth:
            return UIColor.black
        case .dark:
            return UIColor.white
        case .shampan:
            return UIColor.blue
            
        }
    }
    var subtitleTextColor: UIColor {
        switch self {
        case .ligth:
            return UIColor.black
        case .dark:
            return UIColor.black
        case .shampan:
            return UIColor.black
            
        }
    }
    
    var editBtn: UIColor {
        switch self {
        case .ligth:
            return UIColor.blue
        case .dark:
            return UIColor.black
        case .shampan:
            return UIColor.blue
            
        }
    }
}

