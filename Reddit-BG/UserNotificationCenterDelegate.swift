//
//  UserNotificationCenterDelegate.swift
//  Reddit-BG
//
//  Created by Robert Wettstädt on 25/08/2016.
//  Copyright © 2016 Robert Wettstädt. All rights reserved.
//

import Cocoa

class UserNotificationCenterDelegate: NSObject, NSUserNotificationCenterDelegate {
    
    let notificationCenter = NSUserNotificationCenter.defaultUserNotificationCenter()
    var popStatusItem: PopStatusItem
    
    override init() {
        self.popStatusItem = PopStatusItem(image: NSImage())
        
        super.init()
        
        notificationCenter.delegate = self
    }
    
    init(popStatusItem pop: PopStatusItem) {
        self.popStatusItem = pop
        
        super.init()
        
        notificationCenter.delegate = self
    }
    
    @objc func userNotificationCenter(center: NSUserNotificationCenter, didDeliverNotification notification: NSUserNotification) {
        
    }
    
    @objc func userNotificationCenter(center: NSUserNotificationCenter, didActivateNotification notification: NSUserNotification) {
        self.popStatusItem.showPopover()
    }
    
    @objc func userNotificationCenter(center: NSUserNotificationCenter, shouldPresentNotification notification: NSUserNotification) -> Bool {
        return true
    }
    
    func scheduleNotification(subrredit _subreddit: String, previewImage: NSImage, id: String) {
        let notification = NSUserNotification()
        notification.title = "New Background has been set"
        notification.subtitle = "Reddit BG"
        notification.informativeText = _subreddit
        notification.contentImage = previewImage
        notification.identifier = id
        notification.hasActionButton = false
        
        self.notificationCenter.scheduleNotification(notification)
    }
    
}