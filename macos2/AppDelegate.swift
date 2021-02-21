//
//  AppDelegate.swift
//  macos2
//
//  Created by Maxim Meyer on 26.12.20.
//

import Cocoa
import AVFoundation

@main
class AppDelegate: NSObject, NSApplicationDelegate {
 
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        AudioServicesPlayAlertSound(SystemSoundID(1322))
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    
    
    
}

