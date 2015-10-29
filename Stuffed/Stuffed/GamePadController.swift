//
//  GamePadController.swift
//  Stuffed
//
//  Created by Paul Vagner on 10/27/15.
//  Copyright © 2015 Paul Vagner. All rights reserved.
//

import UIKit
import MultipeerConnectivity



class GamePadController: UIViewController, MCNearbyServiceAdvertiserDelegate, MCSessionDelegate {
    
    var session: MCSession!
    var advertiser: MCNearbyServiceAdvertiser!
    var myPeerId: MCPeerID = MCPeerID(displayName: "GrapeDrink")
    
    var boardID: MCPeerID?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        session = MCSession(peer: myPeerId)
        session.delegate = self
        advertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: ["color" : "purple"], serviceType: serviceType)
        advertiser.delegate = self
        advertiser.startAdvertisingPeer()
        
        
        // Do any additional setup after loading the view.
    }
    //MARK: -Advertiser
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: NSData?, invitationHandler: (Bool, MCSession) -> Void) {
        
        print("Inviting Peer \(peerID.displayName)")
        
        if peerID.displayName == "Board" {
            
            boardID = peerID
            
            print(peerID)
            
            print("Accept Invite")
            
//            advertiser.stopAdvertisingPeer()
            
            invitationHandler(true, session)
            
        } else {
            
            print("Decline Invite")
            invitationHandler(false, session)
            
            
        }
        
    }
    
    //MARK: -SESSION
    func session(session: MCSession, didReceiveCertificate certificate: [AnyObject]?, fromPeer peerID: MCPeerID, certificateHandler: (Bool) -> Void) {
    
    certificateHandler(true)

    }
    
    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) {
        
    }
    
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) {
        
    }
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
        
        let states = ["Not Connected", "Connecting", "Connected"]
        
        let stateName = states[state.rawValue]
        
        print(peerID)

        //someone has joined the session
        print("\(peerID.displayName)" + stateName)
        
        print(session.connectedPeers)
        
        
        
    }
    
    
    
    
    
    //MARK: -Buttons
    
    @IBAction func jump(sender: AnyObject) {
        
        let info = [
            
            "action" : "jump",
            
        ]
        
        sendInfo(info)
        print("jump")
    }
    
    
    //MARK: LEFT
    @IBAction func left(sender: AnyObject) {
        
//        let info = [
//            
//            "action" : "move",
//            "direction" : "left"
//        ]
//        
//        print("left")
//        
//        sendInfo(info)
        
        let gameData = GameData(action: .Move, direction: .Left)
        
        sendData(gameData)
        
//        //MARK: //NSKeyedArchiver
//        
//        let data = NSKeyedArchiver.archivedDataWithRootObject(info)
//        
//        if let bID = boardID {
//        
//        _ = try? session.sendData(data, toPeers: [bID], withMode: .Reliable)
        
        
        
//        //MARK: //NSJSONSerialization
//
//        if let data = try? NSJSONSerialization.dataWithJSONObject(info, options: .PrettyPrinted) {
        //
        //       try? session.sendData(data, toPeers: session.connectedPeers, withMode: .Reliable)
        
        //    }
//        }
    }
    //MARK: RIGHT
    @IBAction func right(sender: AnyObject) {
        
        let gameData = GameData(action: .Move, direction: .Right)
        
        sendData(gameData)
        
//        let info = [
//            
//            "action" : "move",
//            "direction" : "right"
//        ]
//         print("right")
//        
//       sendInfo(info)
//        
//        //        //MARK: //NSJSONSerialization
//        //
//        //        if let data = try? NSJSONSerialization.dataWithJSONObject(info, options: .PrettyPrinted) {
//        //
//        //       try? session.sendData(data, toPeers: session.connectedPeers, withMode: .Reliable)
//        
//        //    }
//        
    }
    
    func sendData(gameData: GameData) {
        
        if let bID = boardID {
            
            do {
                
                try session.sendData(gameData.data, toPeers: [bID], withMode: .Reliable)
                
            } catch {
                
                print(error)
                
            }

            
        }
        
    }
    
    func sendInfo(info:[String:String]) {
     
        if let data = try? NSJSONSerialization.dataWithJSONObject(info, options: .PrettyPrinted) {
        
        if let bID = boardID {
            
            //            print(session.connectedPeers)
            
            do {
                
                try session.sendData(data, toPeers: [bID], withMode: .Reliable)
                
            } catch {
                
               print(error)
            
            }
            
        }
        
    }
        
}
    
    @IBAction func shoot(sender: AnyObject) {
        
        let info = [ "action" : "fire" ]
        
        sendInfo(info)
    
        print("fire")
    }
    
    
}


