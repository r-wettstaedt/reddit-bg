//
//  PostPreviewViewController.swift
//  Reddit-BG
//
//  Created by Robert Wettstädt on 27/07/16.
//  Copyright © 2016 Robert Wettstädt. All rights reserved.
//

import Cocoa

class PostPreviewViewController: NSViewController {

    @IBOutlet var postPreview: NSView!
    @IBOutlet weak var _score: NSTextField!
    @IBOutlet weak var _image: NSImageView!
    @IBOutlet weak var _title: NSTextField!
    @IBOutlet weak var _meta: NSTextField!
    @IBOutlet weak var _spinner: NSProgressIndicator!

    var post: RedditPost

    init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, post: RedditPost) {
        self.post = post

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        self.post = RedditPost()

        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func mouseDown(theEvent: NSEvent) {
        NSWorkspace.sharedWorkspace().openURL(NSURL(string: self.post.permalink)!)
    }
    
    func beforeRender() {
        self._spinner.startAnimation(nil)
        self._score.hidden = true
        self._image.hidden = true
        self._title.hidden = true
        self._meta.hidden = true
    }

    func render() {
        self.renderScore()
        self.renderImage()
        self.renderTitle()
        self.renderMeta()
        
        self._spinner.stopAnimation(nil)
        self._score.hidden = false
        self._image.hidden = false
        self._title.hidden = false
        self._meta.hidden = false
    }

    func renderScore() {
        self._score.stringValue = ""

        self._score.stringValue = String(self.post.score)
    }

    func renderImage() {
        self._image.image = nil

        let image = NSImage(contentsOfURL: NSURL(string: self.post.preview)!)
        self._image.image = image
    }

    func renderTitle() {
        self._title.stringValue = ""

        self._title.stringValue = self.post.title

        let height = self._title.attributedStringValue.size().height
        let y = self._title.frame.origin.y
        self._title.frame.origin.y = y + (self._title.frame.height - height) / 2
        self._title.frame.origin.y = y
    }

    func renderMeta() {
        self._meta.stringValue = ""
        
        self._meta.stringValue = self.post.subreddit
    }


}
