//
//  ViewController.swift
//  swag
//
//  Created by Ryan Remaly on 2/21/21.
//

import Cocoa
import SpriteKit
import GameplayKit

class ViewController: NSViewController {

    @IBOutlet var skView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.skView {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                let trackingArea = NSTrackingArea(rect: view.visibleRect, options: [NSTrackingArea.Options.activeAlways ,NSTrackingArea.Options.mouseMoved], owner: self, userInfo: nil)
                
                view.addTrackingArea(trackingArea)
                
                // Present the scene
                view.presentScene(scene)
            }
            
            
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    
    
}

