//
//  GameScene.swift
//  PixelBattle
//
//  Created by Paul Vagner on 10/26/15.
//  Copyright (c) 2015 Paul Vagner. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */

//        physicsWorld.
    
        physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
    
        
        
        
    }
    
//    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
//       /* Called when a touch begins */
//        
//        for touch in touches {
//            let location = touch.locationInNode(self)
//            
//            let pixel = SKShapeNode(rectOfSize: CGSize(width: 20, height: 20))
//            
//            pixel.fillColor = SKColor.orangeColor()
//            
//            pixel.strokeColor = SKColor.blueColor()
//            
//            pixel.lineWidth = 4
//            
//            pixel.position = location
//            
//            pixel.physicsBody = SKPhysicsBody(rectangleOfSize: pixel.frame.size)
//            
//            addChild(pixel)
//            
//            print(children.count)
//            
//            print(frame)
//        }
//    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
