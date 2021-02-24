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
    
    
    var nsView: NSView = NSView()
    @IBOutlet var skView: SKView!
    var mouseLocation: NSPoint? { self.view.window?.mouseLocationOutsideOfEventStream }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.skView {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                scene.size = view.bounds.size
                
                
                nsView.subviews.append(view)
                
                
                

                // Present the scene
                view.presentScene(scene)
                
                
            }
            
            
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    override func viewDidAppear() {
        print(self.view.window)
        
    }
    
    
}

