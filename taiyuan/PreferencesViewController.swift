//
//  PreferencesViewController.swift
//  taiyuan
//
//  Created by Alexander Rohrig on 9/11/20.
//  Copyright © 2020 Alexander Rohrig. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController {
    
    let defaults = UserDefaults.standard

    @IBOutlet weak var rgbFormatPopUp: NSPopUpButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TRUE FOR 8 BIT
        if defaults.bool(forKey: settingsRGBTypeKey) {
            rgbFormatPopUp.selectItem(at: 1)
        }
        else {
            rgbFormatPopUp.selectItem(at: 0)
        }
    }
    
    override func viewDidAppear() {
        self.view.window?.styleMask = [.closable, .titled]
    }
    
    @IBAction func rgbFormatChanged(_ sender: Any) {
        // TRUE FOR 8 BIT
        if rgbFormatPopUp.indexOfSelectedItem == 1 {
            defaults.set(true, forKey: settingsRGBTypeKey)
        }
        else if rgbFormatPopUp.indexOfSelectedItem == 0 {
            defaults.set(false, forKey: settingsRGBTypeKey)
        }
    }
    
    @IBAction func donatePressed(_ sender: Any) {
    }
    
    @IBAction func translationHelpPressed(_ sender: Any) {
    }
    
}
