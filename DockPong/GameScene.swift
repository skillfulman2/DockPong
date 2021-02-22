//
//  GameScene.swift
//  DockPong
//
//  Created by Ryan Remaly on 2/20/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var ball = SKSpriteNode()
    var enemy = SKSpriteNode()
    var human = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        enemy = self.childNode(withName: "enemy") as! SKSpriteNode
        human = self.childNode(withName: "human") as! SKSpriteNode
        
        //ball.physicsBody?.applyImpulse(CGVector(dx: 90000, dy: 90000))
        
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        border.friction = 0
        border.restitution = 1
        
        
        
        self.physicsBody = border
       
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
