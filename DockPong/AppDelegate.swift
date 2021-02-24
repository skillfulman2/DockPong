//
//  AppDelegate.swift
//  swag
//
//  Created by Ryan Remaly on 2/21/21.
//


import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = ViewController() // Your initial view controller.
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
    
    
    /*func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = ViewController() // Your initial view controller.
        window.makeKeyAndVisible()
        self.window = window
        return true
        
    }*/
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    
}
