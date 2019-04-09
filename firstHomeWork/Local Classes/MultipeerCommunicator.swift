//
//  MultipeerCommunicator.swift
//  firstHomeWork
//
//  Created by Денис Сидоренко on 19/03/2019.
//  Copyright © 2019 Денис Сидоренко. All rights reserved.
//

//import Foundation
//import MultipeerConnectivity
//
//class MultipeerCommunicator: NSObject, Communicator {
//    
//    var sessions: MCSession
//    var delegate: CommunicatorDelegate?
//    var userName: String
//    var currentPeers: [MCPeerID] = []
//    var browser: MCNearbyServiceBrowser
//    var advertiser: MCNearbyServiceAdvertiser
//    var userPeerID: MCPeerID
//    var online: Bool = false
//    var lastState = MCSessionState.notConnected
//    weak var onDisconnectDelegate: OnUserDisconnectedDelegate?
//    
//    
//    func sendMessage(message: String, to userID: String, completionHandler: ((Bool, Error?) -> ())?) {
//        let message = Message(text: message)
//        print(sessions.connectedPeers)
//        do {
//            try self.sessions.send(try JSONEncoder().encode(message), toPeers: sessions.connectedPeers, with: .reliable)
//            completionHandler?(true, nil)
//        } catch let error {
//            completionHandler?(false, error)
//        }
//        
//        self.delegate?.didReceiveMessage(text: message.text, fromUser: userName, toUser: userID)
//    }
//    
//    func connectWithUser(userName: String) {
//        let rightPeer = currentPeers.filter { (peer) -> Bool in
//            peer.displayName == userName
//        }
//        if rightPeer.count > 0 {
//            browser.invitePeer(rightPeer.first!, to: sessions, withContext: nil, timeout: 5)
//        }
//    }
//    
//    func disconnectWithUser(userName: String) {
//        self.sessions.disconnect()
//    }
//
//    func reinitAdvertiser(newUserName: String) {
//        self.advertiser.stopAdvertisingPeer()
//        self.browser.stopBrowsingForPeers()
//        self.userName = newUserName
//        self.userPeerID = MCPeerID(displayName: self.userName)
//        self.sessions = MCSession(peer: self.userPeerID)
//        
//        self.advertiser = MCNearbyServiceAdvertiser(peer: userPeerID, discoveryInfo: ["userName": self.userName], serviceType: "tinkoff-chat")
//        self.advertiser.delegate = self
//        self.advertiser.startAdvertisingPeer()
//        
//        self.browser = MCNearbyServiceBrowser(peer: userPeerID, serviceType: "tinkoff-chat")
//        self.browser.startBrowsingForPeers()
//    }
//    
//    init(userName: String) {
//        self.online = true
//        self.userName = userName
//        self.userPeerID = MCPeerID(displayName: self.userName)
//        
//        self.sessions = MCSession(peer: self.userPeerID)
//        self.browser = MCNearbyServiceBrowser(peer: self.userPeerID, serviceType: "tinkoff-chat")
//        self.advertiser = MCNearbyServiceAdvertiser(peer: self.userPeerID, discoveryInfo: ["UserName" : self.userName], serviceType: "tinkoff-chat")
//        
//        super.init()
//        
//        self.advertiser.delegate = self
//        self.browser.delegate = self
//        self.sessions.delegate = self
//        
//        
//        self.advertiser.startAdvertisingPeer()
//        self.browser.startBrowsingForPeers()
//    }
//}
//
//
//extension MultipeerCommunicator : MCNearbyServiceAdvertiserDelegate {
//    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
//        if (!self.sessions.connectedPeers.contains(peerID) && self.sessions.connectedPeers.isEmpty) {
//            invitationHandler(true, self.sessions)
//        } else {
//            invitationHandler(false, nil)
//        }
//    }
//    
//    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
//        self.delegate?.failedToStartAdvertising(error: error)
//    }
//}
//
//
//extension MultipeerCommunicator: MCNearbyServiceBrowserDelegate {
//    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
//        self.currentPeers.append(peerID)
//        
//        self.delegate?.didFoundUser(userID: peerID.displayName, username: info!["userName"])
//    }
//    
//    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
//        self.delegate?.didLostUser(userID: peerID.displayName)
//        self.currentPeers.removeAll(where: {$0 == peerID})
//    }
//}
//
//
//extension MultipeerCommunicator: MCSessionDelegate {
//    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
//        self.lastState = state
//        onDisconnectDelegate?.userDidDisconnected(state: state)
//    }
//    
//    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
//        do {
//            let message = try JSONDecoder().decode(Message.self, from: data)
//            self.delegate?.didReceiveMessage(text: message.text, fromUser: peerID.displayName, toUser: userPeerID.displayName)
//        } catch let err {
//            print(err)
//        }
//    }
//    
//    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
//        
//    }
//    
//    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
//        
//    }
//    
//    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
//        
//    }
//}
//
//
//
//
//
//
//
//
//
