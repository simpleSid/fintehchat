//
//  ConversationsListViewController.swift
//  firstHomeWork
//
//  Created by Денис Сидоренко on 21/02/2019.
//  Copyright © 2019 Денис Сидоренко. All rights reserved.
//

import UIKit

class ConversationsListViewController: UITableViewController {
    
    @IBOutlet weak var profileBarButtonItem: UIBarButtonItem!
    var multipeerManager = CommunicationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorColor = UIColor.biscay
        self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
        self.tableView.backgroundColor = ThemeManager.currentTheme().backgroundColor
        
        
        multipeerManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? Users.onlineUsers.count : Users.oflineUsers.count
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Online" : "History"
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell", for: indexPath) as! ConversationTableViewCell
        
        let dateManager = DateManager.shared
        
        switch indexPath.section {
        case 0:
            
            let currentDay = Calendar.current.dateComponents([.day], from: Users.onlineUsers[indexPath.row].date ?? Date())
            
            dateManager.dateFormater.dateFormat = dateManager.lastMessageDayIsCurrantDay(lastMessage: currentDay)
            
            cell.backgroundColor = UIColor.tidal
            
            cell.nameLabel.text = Users.onlineUsers[indexPath.row].name ?? "name"
            
            cell.timeOfLastMessageLabel.text = dateManager.dateFormater.string(from: Users.onlineUsers[indexPath.row].date ?? Date())
            
            //            cell = ConversationListManager.changeMessagefont(cell: cell, user: Users.onlineUsers[indexPath.row])
            var nameOfFont = ""
            if Users.onlineUsers[indexPath.row].message == nil {
                nameOfFont = "Chalkboard SE"
                cell.lastMessageLabel.text = "No messages yet"
                cell.lastMessageLabel.font = UIFont(name: nameOfFont, size: 17)
            } else {
                nameOfFont = "Apple SD Gothic Neo"
                cell.lastMessageLabel.font = UIFont(name: nameOfFont, size: 17)
                cell.lastMessageLabel.text = Users.onlineUsers[indexPath.row].message
            }
            
            //            cell = ConversationListManager.changeUnreadMessageStyle(cell: cell, user: Users.onlineUsers[indexPath.row])
            if Users.onlineUsers[indexPath.row].hasUnreadMessages {
                cell.lastMessageLabel.font = UIFont(name: nameOfFont + " Bold", size: 17)
            } else {
                cell.lastMessageLabel.font = UIFont(name: nameOfFont, size: 17)
            }
        case 1:
            
            let currentDay = Calendar.current.dateComponents([.day], from: Users.oflineUsers[indexPath.row].date ?? Date())
            
            dateManager.dateFormater.dateFormat = dateManager.lastMessageDayIsCurrantDay(lastMessage: currentDay)
            
            cell.backgroundColor = ThemeManager.currentTheme().backgroundColor
            
            cell.lastMessageLabel.textColor = ThemeManager.currentTheme().titleTextColor
            cell.nameLabel.textColor = ThemeManager.currentTheme().titleTextColor
            cell.timeOfLastMessageLabel.textColor = ThemeManager.currentTheme().titleTextColor
            
            cell.nameLabel.text = Users.oflineUsers[indexPath.row].name ?? "name"
            
            cell.timeOfLastMessageLabel.text = dateManager.dateFormater.string(from: Users.oflineUsers[indexPath.row].date ?? Date())
            
            //            cell = ConversationListManager.changeMessagefont(cell: cell, user: Users.oflineUsers[indexPath.row])
            var nameOfFont = ""
            if Users.oflineUsers[indexPath.row].message == nil {
                nameOfFont = "Chalkboard SE"
                cell.lastMessageLabel.text = "No messages yet"
                cell.lastMessageLabel.font = UIFont(name: nameOfFont, size: 17)
            } else {
                nameOfFont = "Apple SD Gothic Neo"
                cell.lastMessageLabel.font = UIFont(name: nameOfFont, size: 17)
                cell.lastMessageLabel.text = Users.oflineUsers[indexPath.row].message
            }
            //            cell = ConversationListManager.changeUnreadMessageStyle(cell: cell, user: Users.oflineUsers[indexPath.row])
            if Users.oflineUsers[indexPath.row].hasUnreadMessages {
                cell.lastMessageLabel.font = UIFont(name: nameOfFont + " Bold", size: 17)
            } else {
                cell.lastMessageLabel.font = UIFont(name: nameOfFont, size: 17)
            }
        default:
            break
        }
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == "goToConversation" else { return }
        
        let destinationVc = segue.destination as! ConversationTableViewController
        
        if let selectIndex = self.tableView.indexPathForSelectedRow {
            
            switch selectIndex.section {
            case 0:
                destinationVc.title = Users.onlineUsers[selectIndex.row].name
                destinationVc.mcInterlocutor = Users.onlineUsers[selectIndex.row]
            case 1:
                destinationVc.title = Users.oflineUsers[selectIndex.row].name
                destinationVc.mcInterlocutor = Users.onlineUsers[selectIndex.row]
            default:
                break
            }
            
        }
        
    }
    
    
}


extension ConversationsListViewController: CommunicatorDelegate {
    
    func didFoundUser(userID: String, username: String?) {
        print("нашел пользователя и добавил его в массив")
        
        if !Users.users.contains(where: { (user) -> Bool in
            user.name == userID
        }) && userID != multipeerManager.communicator.peerID.displayName {
            Users.users.append(User(name: userID, message: nil, date: Date(), online: true, hasUnreadMessage: true))
        }
        
        
        print("сейчас в массиве онлайн юеров столько \(Users.onlineUsers.count)")
        self.tableView.reloadData()
    }
    
    func didLostUser(userID: String) {
        print("потерял пользователя и убрал его из массива")
        Users.users.removeAll { (user) -> Bool in
            user.name == userID
        }
        self.tableView.reloadData()
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        
        if let index = Users.users.firstIndex(where: { $0.name == fromUser }) {
            Users.users[index].message = text
            Users.users[index].storedMessages.append(StoredMessage(text: text, fromUser: fromUser, toUser: toUser))
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        //        asdfasfd
    }
    
    func failedToStartAdvertising(error: Error) {
        ////sadfasdfsdf
    }
}
