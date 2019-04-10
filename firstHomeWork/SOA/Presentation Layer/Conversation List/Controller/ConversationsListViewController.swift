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
    var users = Userss()
    var onlineStatusService = OnlineStatusService()
    
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
        return section == 0 ? onlineStatusService.getOnlineUsers(users: users.users).count : onlineStatusService.getOflineUsers(users: users.users).count
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Online" : "History"
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell", for: indexPath) as! ConversationTableViewCell
        
        let dateManager = DateManager.shared
        
        switch indexPath.section {
        case 0:
            
            let currentDay = Calendar.current.dateComponents([.day], from: onlineStatusService.getOnlineUsers(users: users.users)[indexPath.row].date ?? Date())
            
            dateManager.dateFormater.dateFormat = dateManager.lastMessageDayIsCurrantDay(lastMessage: currentDay)
            
            cell.backgroundColor = UIColor.tidal
            
            cell.nameLabel.text = onlineStatusService.getOnlineUsers(users: users.users)[indexPath.row].name ?? "name"
            cell.timeOfLastMessageLabel.text = dateManager.dateFormater.string(from: onlineStatusService.getOnlineUsers(users: users.users)[indexPath.row].date ?? Date())
            cell.lastMessageLabel.text = onlineStatusService.getOnlineUsers(users: users.users)[indexPath.row].message
            
            cell = ConversationListManager.changeMessagefont(cell: cell, message: onlineStatusService.getOnlineUsers(users: users.users)[indexPath.row].message)
  
            cell = ConversationListManager.changeUnreadMessageStyle(cell: cell, hasUnreadMessages: onlineStatusService.getOnlineUsers(users: users.users)[indexPath.row].hasUnreadMessages)
            
            
        case 1:
            
            let currentDay = Calendar.current.dateComponents([.day], from: onlineStatusService.getOflineUsers(users: users.users)[indexPath.row].date ?? Date())
            
            dateManager.dateFormater.dateFormat = dateManager.lastMessageDayIsCurrantDay(lastMessage: currentDay)
            
            cell.backgroundColor = ThemeManager.currentTheme().backgroundColor
            
            cell.lastMessageLabel.textColor = ThemeManager.currentTheme().titleTextColor
            cell.nameLabel.textColor = ThemeManager.currentTheme().titleTextColor
            cell.timeOfLastMessageLabel.textColor = ThemeManager.currentTheme().titleTextColor
            
            cell.nameLabel.text = onlineStatusService.getOflineUsers(users: users.users)[indexPath.row].name ?? "name"
            cell.timeOfLastMessageLabel.text = dateManager.dateFormater.string(from: onlineStatusService.getOflineUsers(users: users.users)[indexPath.row].date ?? Date())
            cell.lastMessageLabel.text = onlineStatusService.getOflineUsers(users: users.users)[indexPath.row].message
            
            cell = ConversationListManager.changeMessagefont(cell: cell, message: onlineStatusService.getOflineUsers(users: users.users)[indexPath.row].message)

            cell = ConversationListManager.changeUnreadMessageStyle(cell: cell, hasUnreadMessages: onlineStatusService.getOflineUsers(users: users.users)[indexPath.row].hasUnreadMessages)
            
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
                destinationVc.title = onlineStatusService.getOnlineUsers(users: users.users)[selectIndex.row].name
                destinationVc.mcInterlocutor = onlineStatusService.getOnlineUsers(users: users.users)[selectIndex.row]
            case 1:
                destinationVc.title = onlineStatusService.getOflineUsers(users: users.users)[selectIndex.row].name
                destinationVc.mcInterlocutor = onlineStatusService.getOflineUsers(users: users.users)[selectIndex.row]
            default:
                break
            }
            
        }
        
    }
    
    
}


extension ConversationsListViewController: CommunicatorDelegate {
    
    func didFoundUser(userID: String, username: String?) {
        print("нашел пользователя и добавил его в массив")
        
        if !users.users.contains(where: { (user) -> Bool in
            user.name == userID
        }) && userID != multipeerManager.communicator.peerID.displayName {
            users.users.append(User(name: userID, message: nil, date: Date(), online: true, hasUnreadMessage: true))
        }
        
        
        print("сейчас в массиве онлайн юеров столько \(onlineStatusService.getOnlineUsers(users: users.users).count)")
        self.tableView.reloadData()
    }
    
    func didLostUser(userID: String) {
        print("потерял пользователя и убрал его из массива")
        users.users.removeAll { (user) -> Bool in
            user.name == userID
        }
        self.tableView.reloadData()
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        
        if let index = users.users.firstIndex(where: { $0.name == fromUser }) {
            users.users[index].message = text
            users.users[index].storedMessages.append(StoredMessage(text: text, fromUser: fromUser, toUser: toUser))
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
