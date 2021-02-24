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
    
    var humanScore = SKLabelNode()
    var enemyScore = SKLabelNode()
    
    var score = [Int]()
    
    override func didMove(to view: SKView) {
        
        startGame()
        
        humanScore = self.childNode(withName: "humanScore") as! SKLabelNode
        enemyScore = self.childNode(withName: "enemyScore") as! SKLabelNode
        
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        enemy = self.childNode(withName: "enemy") as! SKSpriteNode
        human = self.childNode(withName: "human") as! SKSpriteNode
        
        
        
        
        
        human.size.width = self.frame.width / 10
        human.size.height = self.frame.height / 40
        
        enemy.position.x = -(self.frame.width / 2 - self.frame.width / 15)
        human.position.x = self.frame.width / 2 - self.frame.width / 15
        
        let options = [NSTrackingArea.Options.mouseMoved, NSTrackingArea.Options.activeInKeyWindow] as NSTrackingArea.Options
    
            
        let trackingArea = NSTrackingArea(rect:CGRect(x: view.frame.maxX / 2, y: 0, width: frame.maxX, height: view.frame.maxY)/*view.frame*/,options:options,owner:self,userInfo:nil)
            view.addTrackingArea(trackingArea)
        
        view.addTrackingArea(trackingArea)
        
        ball.physicsBody?.applyImpulse(CGVector(dx: 40, dy: 40))
        
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        border.friction = 0
        border.restitution = 1
        
        self.physicsBody = border
        
       
    }
    
    func startGame() {
        score = [0, 0]
        
        humanScore.text = "\(score[0])"
        enemyScore.text = "\(score[1])"
    }
    
    func addScore(playerWhoWon: SKSpriteNode) {
        
        ball.position = CGPoint(x: 0, y: 0)
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        
        if (playerWhoWon == human) {
            score[0] += 1
            ball.physicsBody?.applyImpulse(CGVector(dx: -40, dy: -40))
        } else {
            score[1] += 1
            ball.physicsBody?.applyImpulse(CGVector(dx: 40, dy: 40))
        }
        
        humanScore.text = "\(score[0])"
        enemyScore.text = "\(score[1])"
        
        
    }
    
    override func mouseMoved(with event: NSEvent) {
        let location = event.location(in: self)
        
        human.position.y = location.y
    }
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        enemy.run(SKAction.moveTo(y: ball.position.y, duration: 0.12))
        
        if ball.position.x >= human.position.x + frame.size.width / 50 {
            addScore(playerWhoWon: enemy)
        }
        
        else if ball.position.x <= enemy.position.x - frame.size.width / 50 {
            addScore(playerWhoWon: human)
        }
    }
}
