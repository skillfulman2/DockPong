//  DockPong
//  Changed by Ryan Remaly with help from Neil Sardesi

import Cocoa
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    // MARK: Properties
    
    private let contentView = NSImageView(image: NSImage(named: .base)!)
    
    private let bounds: NSImageView = {
        let bounds = NSImageView(image: NSImage(named: .bounds)!)
        bounds.imageScaling = .scaleAxesIndependently
        return bounds
    }()
    
    private let rPaddle: NSImageView = {
        let rPaddle = NSImageView(image: NSImage(named: .rPaddle)!)
        rPaddle.imageScaling = .scaleAxesIndependently
        return rPaddle
    }()
    
    private let lPaddle: NSImageView = {
        let lPaddle = NSImageView(image: NSImage(named: .rPaddle)!)
        lPaddle.imageScaling = .scaleAxesIndependently
        return lPaddle
    }()
    
    private let ball: NSImageView = {
        let eyes = NSImageView(image: NSImage(named: .ball)!)
        eyes.imageScaling = .scaleAxesIndependently
        return eyes
    }()
    
    private var right: Bool?
    private var up: Bool?
    private var score1 = 0
    private var score2 = 0
    
    private weak var moveBallTimer: Timer?
    private weak var moveLeftPaddleTimer: Timer?
    
    // MARK: - Lifecycle
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if !AXIsProcessTrusted() {
            let alert = NSAlert()
            alert.messageText = "Accessibility Permission Needed"
            alert.informativeText = "This app uses accessibility features to find the mouse pointer on your screen."
            alert.addButton(withTitle: "Continue")
            if alert.runModal() == .alertFirstButtonReturn {
                let options = [kAXTrustedCheckOptionPrompt.takeRetainedValue(): true]
                _ = AXIsProcessTrustedWithOptions(options as CFDictionary)
            }
        }
        
        contentView.addSubview(bounds)
        contentView.addSubview(rPaddle)
        contentView.addSubview(lPaddle)
        contentView.addSubview(ball)
        
        
        bounds.frame = NSRect(origin: .baseBoundsOrigin, size: bounds.image!.size)
        rPaddle.frame = NSRect(origin: .baseRPaddleOrigin, size: rPaddle.image!.size)
        lPaddle.frame =  NSRect(origin: .baseLPaddleOrigin, size: lPaddle.image!.size)
        ball.frame = NSRect(origin: .baseBallOrigin, size: ball.image!.size)
        
        NSApp.dockTile.contentView = contentView
        self.right = true
        self.up = true
        self.moveLeftPaddle()
        self.moveBall()
        NSApp.dockTile.display()
        
        
        NSEvent.addLocalMonitorForEvents(
            matching: [.mouseMoved, .leftMouseDragged, .rightMouseDragged, .otherMouseDragged]
        ) { [weak self] in
            guard let self = self else { return $0 }
            self.updateEyes()
            //self.updateBall()
            NSApp.dockTile.display()
            return $0
        }
        
        NSEvent.addGlobalMonitorForEvents(
            matching: [.mouseMoved, .leftMouseDragged, .rightMouseDragged, .otherMouseDragged]
        ) { [weak self] _ in
            guard let self = self else { return }
            self.updateEyes()
            //self.updateBall()
            NSApp.dockTile.display()
        }
        
    }
    
    func applicationDidBecomeActive(_ notification: Notification) {
        
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        
        return false
    }
    
    
    
    // MARK: - Animations
    
    
    
    
    private func moveBall() {
        
        
        guard moveBallTimer == nil else { return }
        
        moveBallTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self]
            _ in
            guard let self = self else { return }
            
            
            if (self.ball.frame.origin.y >= 97) {
                self.ball.frame.origin.y -= 1
                self.ball.frame.origin.x += 1
                self.up! = false
            } else if (self.ball.frame.origin.y <= 16.7) {
                self.ball.frame.origin.y += 1
                self.ball.frame.origin.x -= 1
                self.up! = true
            }
            
            else if ((self.ball.frame.origin.x < self.bounds.frame.width - 5 &&
                        self.right! && !self.up!) || (self.ball.frame.origin.x > 0 && !self.right! && !self.up!)) {
                self.ball.frame.origin.x += 1
                self.ball.frame.origin.y -= 1
                //print("Going Right not hit bounds \(self.right!)")
                
            } else if ((self.ball.frame.origin.x < self.bounds.frame.width - 5 &&
                        self.right! && self.up!) || (self.ball.frame.origin.x > 0 && self.right! && !self.up!)) {
                self.ball.frame.origin.x += 1
                self.ball.frame.origin.y += 1
                //print("Going Right not hit bounds \(self.right!)")
                
            } else if (self.ball.frame.origin.x >= self.bounds.frame.width - 5 && self.right!) {
                self.ball.frame.origin.x = 60
                self.ball.frame.origin.y = 46
                self.right = true
                self.up = false
                
                //print("Going Right hit bounds \(self.right!)")
                
            } else if (self.ball.frame.origin.x <= 0 && !self.right!) {
                self.ball.frame.origin.x += 60
                self.ball.frame.origin.y += 46
                self.right = true
                self.up = false
                //self.right = true
                
                
                //print("Going left hit bounds \(self.right!)")
            } else {
                print("not sure \(self.ball.frame.origin.x)")
            }
            
            NSApp.dockTile.display()
        }
        
    }
    
    private func moveLeftPaddle() {
        
        guard moveLeftPaddleTimer == nil else { return }
        
        moveLeftPaddleTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self]
            _ in
            guard let self = self else { return }
            
            self.lPaddle.frame.origin.y = self.ball.frame.origin.y
            
            NSApp.dockTile.display()
        }
        
    }
    
    private func updateBall() {
        guard AXIsProcessTrusted() else { return }
        
        /// The center of the icon in screen space
        var finderOrigin = NSPoint.zero
        
        
        if let dockIcon = dockIcon() {
            var values: CFArray?
            if AXUIElementCopyMultipleAttributeValues(
                dockIcon,
                [(kAXPositionAttribute as CFString), (kAXSizeAttribute as CFString)] as CFArray,
                .stopOnError,
                &values
            ) == .success {
                var position = CGPoint.zero
                var size = CGSize.zero
                
                (values as! [AXValue]).forEach { axValue in
                    AXValueGetValue(axValue, .cgPoint, &position)
                    AXValueGetValue(axValue, .cgSize, &size)
                }
                
                finderOrigin = NSPoint(
                    x: position.x + size.width / 2.0,
                    y: NSScreen.main!.frame.height / 1.2 - (position.y + size.height / 2.0)
                )
                
                // If the pointer is overlapping the icon
                
            }
        }
        
        //eyes.frame.origin.x = unitEyeX * horizontalScaleFactor + NSPoint.baseEyesOrigin.x
        ball.frame.origin.y = finderOrigin.y
        
        
    }
    
    private func updateEyes() {
        guard AXIsProcessTrusted() else { return }
        
        /// The center of the icon in screen space
        let finderOrigin = NSPoint.zero
        let mouseLocation = NSEvent.mouseLocation
        
        let mouseYRelativeToFinder = mouseLocation.y - finderOrigin.y - 100
        
        if (mouseYRelativeToFinder < 16.7) {
            
            return
        } else if (mouseYRelativeToFinder > 86.9) {
            return
        }
        
        rPaddle.frame.origin.y = mouseYRelativeToFinder
        
        
        
        
        
    }
    
    // MARK: - Accessibility Helpers
    
    /// The accessibility element for the app’s dock tile
    private func dockIcon() -> AXUIElement? {
        let appsWithDockBundleId = NSRunningApplication.runningApplications(withBundleIdentifier: .dockBundleId)
        guard let processId = appsWithDockBundleId.last?.processIdentifier else { return nil }
        let appElement = AXUIElementCreateApplication(processId)
        guard let firstChild = subelements(from: appElement, forAttribute: .axChildren)?.first else { return nil }
        // Reverse to avoid picking up the real Finder in case it’s in the Dock.
        guard let children = subelements(from: firstChild, forAttribute: .axChildren)?.reversed() else { return nil }
        for axElement in children {
            var value: CFTypeRef?
            if AXUIElementCopyAttributeValue(axElement, kAXTitleAttribute as CFString, &value) == .success {
                let appName = Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as! String
                if value as? String == appName { return axElement }
            }
        }
        return nil
    }
    
    private func subelements(from element: AXUIElement, forAttribute attribute: String) -> [AXUIElement]? {
        var subElements: CFArray?
        var count: CFIndex = 0
        if AXUIElementGetAttributeValueCount(element, attribute as CFString, &count) != .success {
            return nil
        }
        if AXUIElementCopyAttributeValues(element, attribute as CFString, 0, count, &subElements) != .success {
            return nil
        }
        return subElements as? [AXUIElement]
    }
    
}

// MARK: - Constants
private extension NSPoint {
    static let baseBoundsOrigin = NSPoint(x: 1, y: 16)
    static let baseRPaddleOrigin = NSPoint(x: 110, y: 46)
    static let baseBallOrigin = NSPoint(x: 61, y: 46)
    static let baseLPaddleOrigin = NSPoint(x: 10, y: 46)
}

private extension String {
    static let axChildren = "AXChildren"
    static let dockBundleId = "com.apple.dock"
    static let realFinderBundleId = "com.apple.finder"
}
