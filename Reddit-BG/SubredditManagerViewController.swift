//
//  SubredditManagerViewController.swift
//  Reddit-BG
//
//  Created by Robert Wettstädt on 04/08/16.
//  Copyright © 2016 Robert Wettstädt. All rights reserved.
//

import Cocoa

protocol SubredditManagerViewControllerDelegate {
    func subredditManagerViewControllerChangedHeight()
}

class SubredditManagerViewController: NSViewController {

    @IBOutlet weak var _addTextField: NSTextField!
    @IBOutlet weak var _addBtn: NSButton!

    let defaults = NSUserDefaults()
    let DEFAULT_SUBREDDITS = [String](arrayLiteral:
            "BotanicalPorn",
            "EarthPorn",
            "FuturePorn",
            "InfraredPorn",
            "SeaPorn",
            "SpacePorn",
            "SummerPorn",
            "ViewPorn",
            "VillagePorn"
    )

    var delegate: SubredditManagerViewControllerDelegate?

    var baseHeight = CGFloat(0)
    var subreddits = [String]()

    var subredditControls = [NSControl]()

    override init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.

        if let subreddits = defaults.stringArrayForKey("subreddits") {
            self.subreddits = subreddits
        } else {
            self.subreddits = self.DEFAULT_SUBREDDITS
        }

        self.baseHeight = self.view.frame.height
        self.setHeight()
        self.renderSubreddits()
    }

    func setHeight() {
        self.view.frame = NSRect(x: 0, y: 0, width: self.view.frame.width, height: self.baseHeight + CGFloat(self.subreddits.count * 25))
        self.delegate?.subredditManagerViewControllerChangedHeight()
    }

    func renderSubreddits() {
        for control in self.subredditControls {
            control.removeFromSuperview()
        }
        self.subredditControls.removeAll()

        if (self.subreddits.count > 0) {
            for index in 0...self.subreddits.count - 1 {
                let y = CGFloat(25 * index + 20)
                let height = CGFloat(17)

                let lbl = NSTextField()
                lbl.editable = false
                lbl.selectable = false
                lbl.bezeled = false
                lbl.drawsBackground = false
                lbl.stringValue = self.subreddits[index]
                lbl.frame = NSRect(x: 20, y: y, width: self._addTextField.frame.width, height: height)
                self.view.addSubview(lbl)
                self.subredditControls.append(lbl)

                let btn = NSButton()
                btn.setButtonType(.MomentaryChangeButton)
                btn.tag = index
                btn.title = "x"
                btn.bordered = false
                btn.frame = NSRect(x: self.view.frame.width - 25 - 20, y: y, width: 25, height: height)
                btn.action = #selector(self.removeSubreddit(_:))
                self.view.addSubview(btn)
                self.subredditControls.append(btn)
            }
        }
    }

    func removeSubreddit(sender: AnyObject) {
        let btn = sender as! NSButton
        if (btn.tag >= 0 && btn.tag < self.subreddits.count) {
            self.subreddits.removeAtIndex(btn.tag)
            self.defaults.setObject(self.subreddits, forKey: "subreddits")
        }

        self.setHeight()
        self.renderSubreddits()
    }

    @IBAction func addSubreddit(sender: AnyObject) {
        let newSubreddit = self._addTextField.stringValue.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: " "))

        var contains = false
        for sr in self.subreddits {
            if sr.lowercaseString == newSubreddit.lowercaseString {
                contains = true
            }
        }

        if (!newSubreddit.isEmpty && !contains) {
            self.subreddits.append(newSubreddit)
            self.defaults.setObject(self.subreddits, forKey: "subreddits")

            self.setHeight()
            self.renderSubreddits()
        }

        self._addTextField.stringValue = ""
    }
}
