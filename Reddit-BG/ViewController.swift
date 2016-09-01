//
//  ViewController.swift
//  Reddit-BG
//
//  Created by Robert Wettstädt on 21/07/16.
//  Copyright © 2016 Robert Wettstädt. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, SubredditManagerViewControllerDelegate {
    
    @IBOutlet weak var _next: NSButton!
    @IBOutlet weak var _expand: NSButton!
    @IBOutlet weak var _postPreviewPlaceholder: NSTextField!
    
    let delegate = NSApplication.sharedApplication().delegate as! AppDelegate
    
    let defaults = NSUserDefaults()
    let notificationCenter = NSUserNotificationCenter.defaultUserNotificationCenter()
    
    var post: RedditPost
    var rf: RedditFetcher
    
    var pp: PostPreviewViewController
    var pr: PreferencesViewController
    var sm: SubredditManagerViewController
    
    var bg: Background
    var nc: UserNotificationCenterDelegate
    
    var baseHeight = CGFloat(0)
    var currentUrl: NSURL? = nil
    var timer: NSTimer? = nil
    
    required init?(coder: NSCoder) {
        self.post = RedditPost()
        self.rf = RedditFetcher(post: self.post)
        
        self.pp = PostPreviewViewController(nibName: "PostPreview", bundle: nil, post: self.post)!
        self.pr = PreferencesViewController(nibName: "Preferences", bundle: nil)!
        self.sm = SubredditManagerViewController(nibName: "SubredditManager", bundle: nil)!
        
        self.bg = Background()
        self.nc = UserNotificationCenterDelegate(popStatusItem: self.delegate.popStatusItem)
        
        super.init(coder: coder)
        
        self.sm.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.addChildViewController(self.pp)
        self.pp.view.frame = NSRect(x: 0, y: 64, width: self.view.frame.size.width, height: 168)
        self.view.addSubview(self.pp.view)
        
        self.addChildViewController(self.pr)
        self.pr.view.frame = NSRect(x: 0, y: -self.pr.view.frame.height, width: self.view.frame.size.width, height: self.pr.view.frame.height)
        self.view.addSubview(self.pr.view)
        
        self.addChildViewController(self.sm)
        self.sm.view.frame = NSRect(x: 0, y: -self.pr.view.frame.height - self.sm.view.frame.height, width: self.view.frame.size.width, height: self.sm.view.frame.height)
        self.view.addSubview(self.sm.view)
        
        self._postPreviewPlaceholder.hidden = true
        
        self.getNextPost(self)
        self.baseHeight = self.view.frame.height
    }
    
    override func viewDidDisappear() {
        self._expand.state = NSOffState
        self.togglePreferences(self)
    }
    
    func startTimer() {
        if let _ = self.timer {
            self.timer?.invalidate()
        }
        let updateInterval = self.defaults.integerForKey("updateInterval")
        print("updating again in \(Double(updateInterval * 60))s")
        self.timer = NSTimer(timeInterval: Double(updateInterval * 60), target: self, selector: #selector(self.getNextPost(_:)), userInfo: nil, repeats: false)
        NSRunLoop.currentRunLoop().addTimer(self.timer!, forMode: NSRunLoopCommonModes)
    }
    
    func obsi() {
        print("observer..")
    }
    
    @IBAction func getNextPost(sender: AnyObject) {
        self.pp.beforeRender()
        rf.fetch(subreddits: self.sm.subreddits, callback: {(post: [String:AnyObject]?) -> () in
            if let _ = post {
                self.pp.render()
                self.bg.set(self.post)
                self.startTimer()
                self.nc.scheduleNotification(subrredit: self.post.subreddit, previewImage: self.pp._image.image!, id: self.bg.currentImageName)
            }
        })
    }
    
    @IBAction func togglePreferences(sender: AnyObject) {
        let popover = self.delegate.popStatusItem.popover
        var height = self.baseHeight
        var y_pr = -self.pr.view.frame.height
        var y_sm = -self.pr.view.frame.height - self.sm.view.frame.height
        
        if self._expand.state == NSOnState {
            height += self.pr.view.frame.height + self.sm.view.frame.height
            y_pr = self.sm.view.frame.height
            y_sm = 0
        }
        
        popover.contentSize = NSSize(width: self.view.frame.width, height: height)
        self.pr.view.frame = NSRect(x: 0, y: y_pr, width: self.view.frame.size.width, height: self.pr.view.frame.height)
        self.sm.view.frame = NSRect(x: 0, y: y_sm, width: self.view.frame.size.width, height: self.sm.view.frame.height)
    }
    
    func preferencesViewControllerChangedHeight() {
        self.togglePreferences(self)
    }
    
    func subredditManagerViewControllerChangedHeight() {
        self.togglePreferences(self)
    }

}

