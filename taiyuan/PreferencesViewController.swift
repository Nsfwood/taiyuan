//
//  PreferencesViewController.swift
//  taiyuan
//
//  Created by Alexander Rohrig on 9/11/20.
//  
//

import Cocoa

class PreferencesViewController: NSViewController {
    
    let defaults = UserDefaults.standard

    @IBOutlet weak var rgbFormatPopUp: NSPopUpButton!
    @IBOutlet weak var colorSpaceLabel: NSTextField!
    @IBOutlet weak var roundButton: NSButton!
    @IBOutlet weak var bugButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorSpaceLabel.stringValue = NSScreen.main?.colorSpace?.localizedName as! String
        bugButton.stringValue = NSLocalizedString("Report a Bug", comment: "Button to report a bug in the app")
        
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
    
    @IBAction func openColorFolderPressed(_ sender: Any) {
        var location = FileManager.default.homeDirectoryForCurrentUser
        location.appendPathComponent("Library/Colors")
        NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: location.absoluteString)
    }
    
    @IBAction func donatePressed(_ sender: Any) {
        let url = URL(string: "https://www.buymeacoffee.com/BeAQzFbUP")!
        NSWorkspace.shared.open(url)
    }
    
    @IBAction func translationHelpPressed(_ sender: Any) {
        let url = URL(string: "https://www.alexanderrohrig.com/translationhelp")!
        NSWorkspace.shared.open(url)
    }
    
    @IBAction func bugPressed(_ sender: Any) {
        let url = URL(string: "https://github.com/Nsfwood/taiyuan/issues")!
        NSWorkspace.shared.open(url)
    }
    
}
