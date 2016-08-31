//
//  AppDelegate.swift
//  Reddit-BG
//
//  Created by Robert Wettstädt on 21/07/16.
//  Copyright © 2016 Robert Wettstädt. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let popStatusItem = PopStatusItem(image: NSImage(named: "StatusbarIcon")!)


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        popStatusItem.windowController = storyboard.instantiateControllerWithIdentifier("PopStatusItem") as? NSWindowController
        
        popStatusItem.highlight = true // Default is false
        popStatusItem.activate = true // Default is false
        
        popStatusItem.showPopover() // Show popover on startup
        
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

