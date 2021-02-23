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
        
        ball.physicsBody?.applyImpulse(CGVector(dx: 40, dy: 40))
        
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        border.friction = 0
        border.restitution = 1
        
        self.physicsBody = border
        
       
    }
    
    override func mouseMoved(with event: NSEvent) {
        let location = event.location(in: self)
        
        human.moveUp(location.y)
    }
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        enemy.run(SKAction.moveTo(y: ball.position.y, duration: 0.12))
    }
}
