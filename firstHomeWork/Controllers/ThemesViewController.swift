//
//  ThemesViewController.swift
//  firstHomeWork
//
//  Created by Денис Сидоренко on 04/03/2019.
//  Copyright © 2019 Денис Сидоренко. All rights reserved.
//

import UIKit

class ThemesViewController: UIViewController {

    
    @IBOutlet weak var lightThemeButton: UIButton!
    @IBOutlet weak var durkThemeButton: UIButton!
    @IBOutlet weak var champangneThemeButton: UIButton!
    
    let theme = ThemeManager.currentTheme()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initInterface()
    }
    
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeThemeAction(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            print("ligth")
            ThemeManager.applyTheme(theme: .ligth)
        case 1:
            print("dark")
            ThemeManager.applyTheme(theme: .dark)
        case 2:
            print("shampan")
            ThemeManager.applyTheme(theme: .shampan)
        default:
            break
        }
        
        self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
    }
    
}
