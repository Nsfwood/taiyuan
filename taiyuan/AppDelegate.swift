//
//  AppDelegate.swift
//  taiyuan
//
//  Created by Alexander Rohrig on 9/10/20.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    lazy var windows = NSWindow()

    @IBAction func addNewPalettePressed(_ sender: Any) {
        let newList = NSColorList(name: "New Palette")
        newList.insertColor(NSColor.white, key: "New Color", at: 0)
        do {
            try newList.write(to: URL(fileURLWithPath: "newpalette.clr"))
        }
        catch {
            print("color list failed to save")
        }
    }
    
    @IBAction func helpPressed(_ sender: Any) {
        let url = URL(string: "https://github.com/Nsfwood/taiyuan/blob/master/README.md#help")!
        NSWorkspace.shared.open(url)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSApplication.shared.isAutomaticCustomizeTouchBarMenuItemEnabled = true
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationDockMenu(_ sender: NSApplication) -> NSMenu? {
        let menu = NSMenu(title: "Open Color Picker")
//        let item = NSMenuItem(title: "Open Color Picker", action: <#T##Selector?#>, keyEquivalent: "+")
        return menu
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag {
            for window in sender.windows {
                window.makeKeyAndOrderFront(self)
            }
        }
        return true
    }

}

