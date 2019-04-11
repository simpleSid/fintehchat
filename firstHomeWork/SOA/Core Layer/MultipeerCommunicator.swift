//
//  Communicator.swift
//  firstHomeWork
//
//  Created by Денис Сидоренко on 17/03/2019.
//  Copyright © 2019 Денис Сидоренко. All rights reserved.
//

import Foundation
import MultipeerConnectivity


protocol Communicator {
    func sendMessage(message: String, to userID: String, completionHandler: ((_ success: Bool, _ error : Error?) -> ())?)
    var delegate: CommunicatorDelegate? { get set }
    var online: Bool { get set }
}

class MultipeerCommunicator: NSObject, Communicator {
    
    //добавить массив пиров
    var delegate: CommunicatorDelegate?
    var online: Bool = false
    var peerID = MCPeerID(displayName: UIDevice.current.name + "Sid")
    let advertiser: MCNearbyServiceAdvertiser
    let browser: MCNearbyServiceBrowser
    var discoveryInfo = ["userName": "mac"]
    var serviceType = "tinkoff-chat"
    var session: MCSession
    
    var testMessage = Mesage(text: "Hello world")
    
    override init() {
        self.advertiser = MCNearbyServiceAdvertiser(peer: self.peerID, discoveryInfo: self.discoveryInfo, serviceType: self.serviceType)
        self.browser = MCNearbyServiceBrowser(peer: self.peerID, serviceType: self.serviceType)
        self.session = MCSession(peer: self.peerID)
        
        
        
        super.init()
        self.session.delegate = self
        self.advertiser.delegate = self
        self.browser.delegate = self
        
        // start browes
        self.advertiser.startAdvertisingPeer()
        self.browser.startBrowsingForPeers()
    }
    
    deinit {
        self.advertiser.stopAdvertisingPeer()
        self.browser.stopBrowsingForPeers()
    }
    
    func sendMessage(message: String, to userID: String, completionHandler: ((Bool, Error?) -> ())?) {
        let jsonEncoder = JSONEncoder()
        let msg = Mesage(text: message)
        if let data = try? jsonEncoder.encode(msg) {
            do {
                try self.session.send(data, toPeers: self.session.connectedPeers, with: .reliable)
            } catch let error {
                print("cannot send message \(error)")
            }
            
        }
    }
}

// MARK: AdvertiserDelegate
extension MultipeerCommunicator: MCNearbyServiceAdvertiserDelegate {

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        
        if self.session.connectedPeers.contains(peerID) {
            print("cannot recive invite from PEER \(peerID.displayName)")
            invitationHandler(false, nil)
        } else {
            print("recive invite from PEER \(peerID.displayName)")
            invitationHandler(true, self.session)
        }
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
//        print("не смогли сделать адвертайзер")
        self.delegate?.failedToStartAdvertising(error: error)

    }

}

// MARK: BrowserDelegate
extension MultipeerCommunicator: MCNearbyServiceBrowserDelegate {

    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        if peerID != self.peerID {
            browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 10)
            self.delegate?.didFoundUser(userID: peerID.displayName, username: info!["userName"])
        }
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {

        self.delegate?.didLostUser(userID: peerID.displayName)
       print("lost user with name\(peerID.displayName)")
        //добавить работу с массивом пиров

    }

    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {

        self.delegate?.failedToStartAdvertising(error: error)

    }

}

// MARK: SessionDelegate
extension MultipeerCommunicator: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        print("!!!!!!!print peer \(state) with \(peerID.displayName)", state.rawValue)
        
        switch state {
        case .connecting:
            print("connecting")
        case .connected:
            print("connected")
        case .notConnected:
            print("not connected")
        }
        
        // будем запрещать нажимать на кнопки
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("recive data")
        do {
            let message = try JSONDecoder().decode(Mesage.self, from: data)
            print(message.text, message.messageId,peerID.displayName)
            self.delegate?.didReceiveMessage(text: message.text, fromUser: peerID.displayName, toUser: self.peerID.displayName)
        } catch let error {
            print("reciving error \(error)")
        }
        // будем принимать сообщения
    }


    // dont tuch
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {

    }
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {

    }
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {

    }
}
