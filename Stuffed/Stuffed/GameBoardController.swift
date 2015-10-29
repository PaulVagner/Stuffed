//
//  ViewController.swift
//  Stuffed
//
//  Created by Paul Vagner on 10/27/15.
//  Copyright © 2015 Paul Vagner. All rights reserved.
//

import UIKit

import MultipeerConnectivity

import SpriteKit

typealias PeerInfo = [DisplayName:[String:String]?]

class GameBoardController: UIViewController, MCNearbyServiceBrowserDelegate, MCSessionDelegate {
    
    var session: MCSession!
    
    var browser: MCNearbyServiceBrowser!
    
    var myPeerId: MCPeerID = MCPeerID(displayName: "Board")
    
    let scene = GameBoardScene(fileNamed: "GameBoard")
    
    var peerInfo: PeerInfo = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let skView = view as? SKView {
            
            skView.presentScene(scene)
            skView.ignoresSiblingOrder = true
        
        }
        
        ////////////////////////////////////
        //////////////////////////////////// BROWSER
        ////////////////////////////////////
        //MARK: - Browser

        
        session = MCSession(peer: myPeerId)
        session.delegate = self
        
        browser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)
        
        browser.delegate = self
        
        //browser.stopBrowsingForPeers()
        
        
    }
    
    
    
    var waitingPeers: [MCPeerID] = []
    
    var sendingInvite: Bool = false
    
    func sendInvite() {
        
        print(waitingPeers, terminator: "\n\n")
        
        if let peerID = waitingPeers.first {
            
            sendingInvite = true
            
            waitingPeers.removeFirst()
            
            browser.invitePeer(peerID, toSession: session, withContext: nil, timeout: 10)
            
            
            
        }
        
    }
    
    func browser(browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        
        if session.connectedPeers.contains(peerID) { return }
        
        browser.stopBrowsingForPeers()
        
        print("FoundPeer \(peerID.displayName)")
        
        print("Found Peer Info \(info)")
        
        peerInfo[peerID.displayName] = info
        
        if waitingPeers.contains(peerID) { return }
        
        waitingPeers.append(peerID)
        
        if !sendingInvite { sendInvite() }
        
    }
    
    
    
    func browser(browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        
        print("LostPeer \(peerID.displayName)")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Session
    
    
    
    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) {
        
        //if a file was received
        
        
    }
    
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        
        //if data is received
        
        print(data)
        
        
        if let gameData = GameData.data(data) {
            
            if let action = gameData.action where .Move == action {
            
                scene?.movePixel(peerID.displayName, direction: gameData.direction!.rawValue)
            
            }
            
        }
        
        
        if let info = try? NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [String:String]{
            
            //            if let info = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [String:String] {
            
            
            if let action = info?["action"] where action == "move", let direction = info?["direction"] {
                
                //                if let direction = info["direction"] {
                
                scene?.movePixel(peerID.displayName, direction: direction)
                
            }
            
            if let action = info?["action"] where action == "jump" {
                
                scene?.jumpPixel(peerID.displayName)
                
            }
            
            if let action = info?["action"] where action == "fire" {
                
                scene?.shootPixel(peerID.displayName)
            
            }
            
        }
        
        
    }
    
    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
        //if streaming data is received
    }
    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) {
        
        //if started receiving file
    }
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
        
        let states = ["Not Connected", "Connecting", "Connected"]
        
        let stateName = states[state.rawValue]
        
        //someone has joined the session
        print("\(peerID.displayName)" + stateName)
        
        print(session)
        
        if state != .Connecting {
            
            sendingInvite = false
            
            sendInvite()
            
            //
            //            browser.stopBrowsingForPeers()
            //            browser.startBrowsingForPeers()
        }
        
        if state == .Connected {
            
            print(stateName)
            
            if let color = peerInfo[peerID.displayName]??["color"] {
                
                scene?.addPixel(peerID.displayName, colorName: color)
                
            } else {
            
            
            scene?.addPixel(peerID.displayName)
            }
            
        }
        if state == .NotConnected {
            
            //removes pixel with name from screen
        
           scene?.removePixel(peerID.displayName)
            
        
        }
    
    }
    
}





