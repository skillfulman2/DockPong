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
    
    let frame = CGRect(origin: CGPoint(x: 30, y: 100), size: CGSize(width: 30, height: 30))
    let frame2 = CGRect(origin: CGPoint(x: 85, y: 100), size: CGSize(width: 30, height: 30))
    
    var view: NSView?
    var view2: NSView?
    
    
    private var direction = Directions.nW
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
        self.view = NSView(frame: self.frame)
        
        self.view2 = NSView(frame: self.frame2)
        
        let score1View = NSTextField(string: "\(self.score1)")
        let score2View = NSTextField(string: "\(self.score2)")
        
        score1View.textColor = NSColor.white
        score1View.backgroundColor = NSColor.clear
     
        score1View.isBordered = false
        
        score2View.textColor = NSColor.white
        score2View.backgroundColor = NSColor.clear
        score2View.isBordered = false
        
        self.view!.layer?.backgroundColor = NSColor.clear.cgColor
        self.view!.layer?.backgroundColor = NSColor.clear.cgColor
        
        self.view!.addSubview(score1View)
        self.view2!.addSubview(score2View)
        
        self.view!.wantsLayer = true
        self.view2!.wantsLayer = true
        
        contentView.addSubview(bounds)
        contentView.addSubview(rPaddle)
        contentView.addSubview(lPaddle)
        contentView.addSubview(ball)
        contentView.addSubview(self.view!)
        contentView.addSubview(self.view2!)
        
        bounds.frame = NSRect(origin: .baseBoundsOrigin, size: bounds.image!.size)
        rPaddle.frame = NSRect(origin: .baseRPaddleOrigin, size: rPaddle.image!.size)
        lPaddle.frame =  NSRect(origin: .baseLPaddleOrigin, size: lPaddle.image!.size)
        ball.frame = NSRect(origin: .baseBallOrigin, size: ball.image!.size)
        
        NSApp.dockTile.contentView = contentView
        self.moveLeftPaddle()
        
        NSApp.dockTile.display()
        
        self.moveBall()
        NSEvent.addLocalMonitorForEvents(
            matching: [.mouseMoved, .leftMouseDragged, .rightMouseDragged, .otherMouseDragged]
        ) { [weak self] in
            guard let self = self else { return $0 }
            self.moveRightPaddle()
            //self.updateBall()
            NSApp.dockTile.display()
            return $0
        }
        
        NSEvent.addGlobalMonitorForEvents(
            matching: [.mouseMoved, .leftMouseDragged, .rightMouseDragged, .otherMouseDragged]
        ) { [weak self] _ in
            guard let self = self else { return }
            self.moveRightPaddle()
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
            
            
            // Just going to stick with these 4 directions of the ball for simplicity sake
            // The open source community can change it as they deem fit
            switch self.direction {
            
            case .nE:
                self.ball.frame.origin.y += 1
                self.ball.frame.origin.x += 1
            case .sE:
                self.ball.frame.origin.y -= 1
                self.ball.frame.origin.x += 1
            case .sW:
                self.ball.frame.origin.y -= 1
                self.ball.frame.origin.x -= 1
            case .nW:
                self.ball.frame.origin.y += 1
                self.ball.frame.origin.x -= 1
                
            }
            if (self.ball.frame.origin.y >= 97) {
                if self.direction == .nE {
                    self.direction = .sE
                } else {
                    self.direction = .sW
                }
            } else if (self.ball.frame.origin.y <= 16.7) {
                if self.direction == .sE {
                    self.direction = .nE
                } else {
                    self.direction = .nW
                }
            } else if ((self.ball.frame.origin.y >= self.rPaddle.frame.origin.y - 5 && self.ball.frame.origin.y <= self.rPaddle.frame.origin.y + self.rPaddle.frame.height) && (self.ball.frame.origin.x >= self.rPaddle.frame.origin.x - 4 && self.ball.frame.origin.x <= self.rPaddle.frame.origin.x + 3.5  )) {
                if self.direction == .nE {
                    self.direction = .nW
                } else {
                    self.direction = .sW
                }
            } else if ((self.ball.frame.origin.y >= self.lPaddle.frame.origin.y - 5 && self.ball.frame.origin.y <= self.lPaddle.frame.origin.y + self.lPaddle.frame.height) && (self.ball.frame.origin.x <= self.lPaddle.frame.origin.x + 4 && self.ball.frame.origin.x >= self.lPaddle.frame.origin.x - 3.5)) {
                if self.direction == .nW {
                    self.direction = .nE
                } else {
                    self.direction = .sE
                }
            } else if (self.ball.frame.origin.x >= self.rPaddle.frame.origin.x + 20) {
                self.score1 += 1
                let score1View = NSTextField(string: "\(self.score1)")
                
                score1View.textColor = NSColor.white
                score1View.backgroundColor = NSColor.black
                score1View.isBordered = false
                
                self.view?.subviews.remove(at: 0)
                self.view?.addSubview(score1View)
                
                self.direction = .nW
                self.ball.frame.origin.x = 61
                self.ball.frame.origin.y = 46
            } else if (self.ball.frame.origin.x <= self.lPaddle.frame.origin.x - 20) {
                
                self.score2 += 1
                let score1View = NSTextField(string: "\(self.score2)")
                
                score1View.textColor = NSColor.white
                score1View.backgroundColor = NSColor.black
             
                score1View.isBordered = false
                
                self.view2?.subviews.remove(at: 0)
                self.view2?.addSubview(score1View)
                
                
                
                self.direction = .nE
                self.ball.frame.origin.x = 61
                self.ball.frame.origin.y = 46
            }
            
            
            NSApp.dockTile.display()
        }
        
    }
    
    private func moveLeftPaddle() {
        
        guard moveLeftPaddleTimer == nil else { return }
        
        
        moveLeftPaddleTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self]
            _ in
            guard let self = self else { return }
            
            self.lPaddle.frame.origin.y = self.ball.frame.origin.y / 1.4
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
                
                
            }
        }
        
        ball.frame.origin.y = finderOrigin.y
        
        
    }
    
    private func moveRightPaddle() {
        guard AXIsProcessTrusted() else { return }
        
        /// The center of the icon in screen space
        let finderOrigin = NSPoint.zero
        let mouseLocation = NSEvent.mouseLocation
        
        let mouseYRelativeToFinder = mouseLocation.y - finderOrigin.y
        
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
        
        
        guard let children = subelements(from: firstChild, forAttribute: .axChildren) else { return nil }
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



enum Directions {
    case nW
    case sW
    case nE
    case sE
}
