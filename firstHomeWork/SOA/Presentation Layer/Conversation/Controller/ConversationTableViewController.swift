//
//  DialogTableViewController.swift
//  firstHomeWork
//
//  Created by Денис Сидоренко on 24/02/2019.
//  Copyright © 2019 Денис Сидоренко. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ConversationTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var sendMessageButton: UIButton!
    
    let multipeerManager = CommunicationManager()
    
    var mcInterlocutor: User!
    let communicationManager = CommunicationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
        
        
        communicationManager.delegate = self
        // hide keyboard
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mcInterlocutor.storedMessages.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellInside = tableView.dequeueReusableCell(withIdentifier: "incomingMessage", for: indexPath) as! DialogTableViewCell
        let cellOutside = tableView.dequeueReusableCell(withIdentifier: "outgoingMessage", for: indexPath) as! DialogTableViewCell

        if mcInterlocutor.name == mcInterlocutor.storedMessages[indexPath.row].fromUser {
            cellInside.message.text = mcInterlocutor.storedMessages[indexPath.row].text
            return cellInside
        } else {
            cellOutside.message.text = mcInterlocutor.storedMessages[indexPath.row].text
            return cellOutside
        }
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
        let myName = communicationManager.communicator.peerID.displayName
        if let text = inputTextField.text, let name = mcInterlocutor.name {
            mcInterlocutor.storedMessages.append(StoredMessage(text: text, fromUser: myName, toUser: name))
            communicationManager.communicator.sendMessage(message: text, to: name, completionHandler: nil)
        }
        tableView.reloadData()
    }
    
    
}

extension ConversationTableViewController: CommunicatorDelegate {

    func didFoundUser(userID: String, username: String?) {

    }

    func didLostUser(userID: String) {
        print("lost user")
    }

    func failedToStartBrowsingForUsers(error: Error) {

    }

    func failedToStartAdvertising(error: Error) {

    }

    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        print("did recive")
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }

    }


}




