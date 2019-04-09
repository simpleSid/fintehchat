//
//  ViewController.swift
//  firstHomeWork
//
//  Created by Денис Сидоренко on 07/02/2019.
//  Copyright © 2019 Денис Сидоренко. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let logManager = LogManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var a = UILabel()
        
        logManager.isLoggedState = true
        
        logManager.printCurrentState(text: "\(#function)", isLogged: logManager.isLoggedState)
        
        a = UILabel(frame: CGRect(x: view.bounds.width / 2 - 50, y: 200, width: 100 , height: 20))
        a.backgroundColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
        view.addSubview(a)
//        a.translatesAutoresizingMaskIntoConstraints = false
//        a.leftAnchor.constraint(equalTo: view.bounds.width / 2, constant: <#T##CGFloat#>)
        
        let f = view.bounds.width
        print(f ?? "nil")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logManager.printCurrentState(text: "\(#function)", isLogged: logManager.isLoggedState)
    }

    override func viewWillLayoutSubviews() {
        logManager.printCurrentState(text: "\(#function)", isLogged: logManager.isLoggedState)
    }
    
    override func viewDidLayoutSubviews() {
        logManager.printCurrentState(text: "\(#function)", isLogged: logManager.isLoggedState)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let ff = view.bounds.width
        print(ff ?? "nil")
        logManager.printCurrentState(text: "\(#function)", isLogged: logManager.isLoggedState)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        logManager.printCurrentState(text: "\(#function)", isLogged: logManager.isLoggedState)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        logManager.printCurrentState(text: "\(#function)", isLogged: logManager.isLoggedState)
    }
}


