//
//  Preferences.swift
//  Reddit-BG
//
//  Created by Robert Wettstädt on 21/08/2016.
//  Copyright © 2016 Robert Wettstädt. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController {
    
    @IBOutlet weak var _updateInterval: NSTextField!
    @IBOutlet weak var _updateIntervalStepper: NSStepper!
    
    let defaults = NSUserDefaults()
    let DEFAULT_UPDATE_INTERVAL = 60
    
    override init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        var updateInterval = self.defaults.integerForKey("updateInterval")
        if (updateInterval == 0) {
            updateInterval = self.DEFAULT_UPDATE_INTERVAL
        }
        self._updateInterval.stringValue = String(updateInterval)
        self.updateIntervalChanged(nil)
    }
    
    @IBAction func updateIntervalChanged(sender: AnyObject?) {
        var i = Double(self._updateInterval.stringValue)
        if i < self._updateIntervalStepper.minValue {
            i = self._updateIntervalStepper.minValue
        }
        if i > self._updateIntervalStepper.maxValue {
            i = self._updateIntervalStepper.maxValue
        }
        
        let _i = Int(i!)
        self._updateInterval.stringValue = String(_i)
        self._updateIntervalStepper.stringValue = String(_i)
        self.defaults.setInteger(_i, forKey: "updateInterval")
    }
    
    @IBAction func updateIntervalStepperChanged(sender: AnyObject) {
        self._updateInterval.stringValue = self._updateIntervalStepper.stringValue
        self.defaults.setInteger(Int(self._updateInterval.stringValue)!, forKey: "updateInterval")
    }
}
