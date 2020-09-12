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
    @IBOutlet weak var colorSpaceLabel: NSTextField!
    @IBOutlet weak var roundButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TRUE FOR 8 BIT
        if defaults.bool(forKey: settingsRGBTypeKey) {
            rgbFormatPopUp.selectItem(at: 1)
            roundButton.state = .off
            roundButton.isEnabled = false
        }
        else {
            rgbFormatPopUp.selectItem(at: 0)
            roundButton.isEnabled = true
            if defaults.bool(forKey: settingsRoundRGBKey) {
                roundButton.state = .on
            }
            else {
                roundButton.state = .off
            }
        }
    }
    
    override func viewDidAppear() {
        self.view.window?.styleMask = [.closable, .titled]
    }
    
    @IBAction func rgbFormatChanged(_ sender: Any) {
        // TRUE FOR 8 BIT
        if rgbFormatPopUp.indexOfSelectedItem == 1 {
            defaults.set(true, forKey: settingsRGBTypeKey)
            roundButton.isEnabled = false
            roundButton.state = .off
        }
        else if rgbFormatPopUp.indexOfSelectedItem == 0 {
            defaults.set(false, forKey: settingsRGBTypeKey)
            roundButton.isEnabled = true
            if defaults.bool(forKey: settingsRoundRGBKey) {
                roundButton.state = .on
            }
            else {
                roundButton.state = .off
            }
        }
    }
    
    @IBAction func roundPressed(_ sender: Any) {
        if roundButton.state == .on {
            defaults.set(true, forKey: settingsRoundRGBKey)
        }
        else if roundButton.state == .off {
            defaults.set(false, forKey: settingsRoundRGBKey)
        }
    }
    
    @IBAction func donatePressed(_ sender: Any) {
        let url = URL(string: "https://www.buymeacoffee.com/BeAQzFbUP")!
        NSWorkspace.shared.open(url)
    }
    
    @IBAction func translationHelpPressed(_ sender: Any) {
        let url = URL(string: "https://www.alexanderrohrig.com/translationhelp")!
        NSWorkspace.shared.open(url)
    }
    
}
