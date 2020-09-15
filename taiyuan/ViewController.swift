//
//  ViewController.swift
//  taiyuan
//
//  Created by Alexander Rohrig on 9/10/20.
//

import Cocoa
import Foundation

let settingsRGBTypeKey = "taiyuan.settings.rgbDisplayType"
let settingsRoundRGBKey = "taiyuan.settings.rgbRoundFloatingPoint"

class ViewController: NSViewController {
    
    var bookmarks = [URL: Data]()
    var lists = NSColorList.availableColorLists
    var listIndex = 0
    var currentColorListIsEditable = false
    
    let defaults = UserDefaults.standard
    
    let pasteboard = NSPasteboard.general

    @IBOutlet weak var colorListPicker: NSPopUpButton!
    @IBOutlet weak var tableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        NSLocalizedString("Delete Color", comment: "")
        
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: NSLocalizedString("Copy Color as HEX", comment: "Right click menu option to copy color as  hex code"), action: #selector(tableViewCopyHEXClicked(_:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: NSLocalizedString("Copy Color as RGB", comment: "Right  click  menu option to  copy color  as  rgb code"), action: #selector(tableViewCopyRGBClicked(_:)), keyEquivalent: ""))
        
        if currentColorListIsEditable {
            menu.addItem(NSMenuItem(title: NSLocalizedString("Add Color Below", comment: "Right click menu option to add another color below selected color"), action: #selector(tableViewAddClicked(_:)), keyEquivalent: ""))
            menu.addItem(NSMenuItem(title: NSLocalizedString("Rename Color", comment: "Right click menu option to rename selected  color"), action: #selector(tableViewRenameClicked(_:)), keyEquivalent: ""))
            menu.addItem(NSMenuItem(title: NSLocalizedString("Delete Color", comment: "Right click meny option to  delete selected color"), action: #selector(tableViewDeleteClicked(_:)), keyEquivalent: ""))
        }
        
        tableView.menu = menu
        tableView.delegate = self
        tableView.dataSource = self
        
        colorListPicker.removeAllItems()
        
        for list in lists {
            colorListPicker.addItem(withTitle: list.name ?? "No Name")
        }
        
//        loadBookmarks()
//        print(bookmarks)
//        if bookmarks.isEmpty {
//            let url = allowFolder()
//            saveBookmarks()
//        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func colorListPicked(_ sender: Any) {
        let l = lists[colorListPicker.indexOfSelectedItem]
        
        if l.isEditable {
            currentColorListIsEditable = true
        }
        else {
            currentColorListIsEditable = false
        }
        
        if l.name == "System" {
            let alert = NSAlert()
            alert.messageText = "Unable to Show This Palette"
            alert.informativeText = "Due to an unknown error, we are unable to show this color palette. We are working on a fix."
            alert.alertStyle = .critical
            alert.addButton(withTitle: "OK")
            alert.runModal()
            
            colorListPicker.selectItem(at: 0)
        }
        else {
            listIndex = colorListPicker.indexOfSelectedItem
            print(l)
            let keys = l.allKeys
            print(keys)
            tableView.reloadData()
        }
    }
    
    @IBAction func colorPickerPressed(_ sender: Any) {
        NSApplication.shared.orderFrontColorPanel(self)
    }
    
    @objc private func tableViewCopyHEXClicked(_ sender: AnyObject) {
        let colorName = lists[listIndex].allKeys[tableView.clickedRow]
        let colorHex = lists[listIndex].color(withKey: colorName)?.hexString
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString(colorHex!, forType: .string)
    }
    
    @objc private func tableViewCopyRGBClicked(_ sender: AnyObject) {
        let colorName = lists[listIndex].allKeys[tableView.clickedRow]
        let color = lists[listIndex].color(withKey: colorName)
        var stringToCopy = ""
        if let color = color {
            let colorR = color.redComponent
            let colorG = color.greenComponent
            let colorB = color.blueComponent
            
            if defaults.bool(forKey: settingsRGBTypeKey) {
                stringToCopy = "\(Int(round(colorR*255))), \(Int(round(colorG*255))), \(Int(round(colorB*255)))"
            }
            else {
                stringToCopy = "\(colorR), \(colorG), \(colorB)"
            }
            
            pasteboard.declareTypes([.string], owner: nil)
            pasteboard.setString(stringToCopy, forType: .string)
        }
    }
    
    @objc private func tableViewAddClicked(_ sender: AnyObject) {
//        let new = NSColor(named: "New Color")
    }
    
    @objc private func tableViewRenameClicked(_ sender: AnyObject) {
        
    }
    
    @objc private func tableViewDeleteClicked(_ sender: AnyObject) {
        
    }
    
    func getListOfColorLists() {
        let list = NSColorList.availableColorLists
        print(list)
    }

    func fileExists(_ url: URL) -> Bool
    {
        var isDir = ObjCBool(false)
        let exists = FileManager.default.fileExists(atPath: url.path, isDirectory: &isDir)

        return exists
    }

    func bookmarkURL() -> URL
    {
        let urls = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        let appSupportURL = urls[urls.count - 1]
        let url = appSupportURL.appendingPathComponent("Bookmarks.dict")
        return url
    }

    func loadBookmarks()
    {

        let url = bookmarkURL()
        if fileExists(url)
        {
            do
            {
                let fileData = try Data(contentsOf: url)
                if let fileBookmarks = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(fileData) as! [URL: Data]?
                {
                    bookmarks = fileBookmarks
                    for bookmark in bookmarks
                    {
                        restoreBookmark(bookmark)
                    }
                }
            }
            catch
            {
                print ("Couldn't load bookmarks")
            }

        }
    }

    func saveBookmarks()
    {
        let url = bookmarkURL()
        do
        {
            let data = try NSKeyedArchiver.archivedData(withRootObject: bookmarks, requiringSecureCoding: false)
            try data.write(to: url)
        }
        catch
        {
            print("Couldn't save bookmarks")
        }
    }

    func storeBookmark(url: URL)
    {
        do
        {
            let data = try url.bookmarkData(options: NSURL.BookmarkCreationOptions.withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
            bookmarks[url] = data
        }
        catch
        {
            Swift.print ("Error storing bookmarks")
        }

    }

    func restoreBookmark(_ bookmark: (key: URL, value: Data))
    {
        let restoredUrl: URL?
        var isStale = false

        Swift.print ("Restoring \(bookmark.key)")
        do
        {
            restoredUrl = try URL.init(resolvingBookmarkData: bookmark.value, options: NSURL.BookmarkResolutionOptions.withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale)
        }
        catch
        {
            Swift.print ("Error restoring bookmarks")
            restoredUrl = nil
        }

        if let url = restoredUrl
        {
            if isStale
            {
                Swift.print ("URL is stale")
            }
            else
            {
                if !url.startAccessingSecurityScopedResource()
                {
                    Swift.print ("Couldn't access: \(url.path)")
                }
            }
        }

    }

    func allowFolder() -> URL?
    {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = true
        openPanel.canChooseFiles = false
        openPanel.begin
            { (result) -> Void in
                if result == NSApplication.ModalResponse.OK//NSFileHandlingPanelOKButton
                {
                    let url = openPanel.url
                    self.storeBookmark(url: url!)
                }
        }
        return openPanel.url
    }

    // reading .CLR
//    extension String {
//        func lowercasedFirstLetter() -> String {
//            return prefix(1).lowercased() + dropFirst()
//        }
//
//        mutating func lowercaseFirstLetter() {
//            self = self.lowercasedFirstLetter()
//        }
//    }
//
//    func floatToInt(_ f : CGFloat) -> Int {
//        return Int(f * 255)
//    }
//
//    let colorList = NSColorList.init(name: "clr", fromFile: "/Path/To/Yourfile.clr")
//    if let allKeys = colorList?.allKeys {
//        for key in allKeys {
//            if let color = colorList?.color(withKey: key) {
//                let red = floatToInt(color.redComponent)
//                let green = floatToInt(color.greenComponent)
//                let blue = floatToInt(color.blueComponent)
//                let hexString = NSString(format: "#%02X%02X%02X", red, green, blue)
//                let name = key.description.replacingOccurrences(of: " ", with: "").lowercasedFirstLetter()
//                print(name, red, green, blue, hexString)
//                // print("static let \(name) = UIColor.init(\"\(hexString)\")")
//           }
//         }
//    }

}

extension ViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return lists[listIndex].allKeys.count
    }
}

extension ViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let currentColor = lists[listIndex].allKeys[row]
        
        if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "nameCol") {
            let cell = NSUserInterfaceItemIdentifier(rawValue: "nameCell")
            guard let view = tableView.makeView(withIdentifier: cell, owner: self) as? NSTableCellView else { return nil }
            view.textField?.stringValue = "\(currentColor)"
            return view
        }
        else if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "rgbCol") {
            let cell = NSUserInterfaceItemIdentifier(rawValue: "nameCell")
            guard let view = tableView.makeView(withIdentifier: cell, owner: self) as? NSTableCellView else { return nil }
            let r = lists[listIndex].color(withKey: currentColor)?.redComponent
            let g = lists[listIndex].color(withKey: currentColor)?.greenComponent
            let b = lists[listIndex].color(withKey: currentColor)?.blueComponent
            if let r = r {
                if let g = g {
                    if let b = b {
                        if defaults.bool(forKey: settingsRGBTypeKey) {
                            view.textField?.stringValue = "\(Int(round(r*255))), \(Int(round(g*255))), \(Int(round(b*255)))"
                        }
                        else {
                            if defaults.bool(forKey: settingsRoundRGBKey) {
                                view.textField?.stringValue = "\(round(r * 100) / 100), \(round(g * 100) / 100), \(round(b * 100) / 100)"
                            }
                            else {
                                view.textField?.stringValue = "\(r), \(g), \(b)"
                            }
                        }
                    }
                }
            }
            view.textField?.font = NSFont.monospacedSystemFont(ofSize: NSFont.systemFontSize(for: .regular), weight: .regular)
            return view
        }
        else if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "hexCol") {
            let cell = NSUserInterfaceItemIdentifier(rawValue: "nameCell")
            guard let view = tableView.makeView(withIdentifier: cell, owner: self) as? NSTableCellView else { return nil }
            let c = lists[listIndex].color(withKey: currentColor)?.hexString
            if let c = c {
                view.textField?.stringValue = c
            }
            view.textField?.font = NSFont.monospacedSystemFont(ofSize: NSFont.systemFontSize(for: .regular), weight: .regular)
            return view
        }
        else if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "preCol") {
            let cell = NSUserInterfaceItemIdentifier(rawValue: "nameCell")
            guard let view = tableView.makeView(withIdentifier: cell, owner: self) as? NSTableCellView else { return nil }
            view.textField?.drawsBackground = true
            view.textField?.stringValue = " "
            view.textField?.backgroundColor = lists[listIndex].color(withKey: currentColor)
            return view
        }
        
        return nil
    }
}

//extension ViewController: NSTouchBarDelegate {
//    override func makeTouchBar() -> NSTouchBar? {
//        let touchbar = NSTouchBar()
//        touchbar.delegate = self
////        touchbar.customizationIdentifier = .travelBar
////        touchbar.defaultItemIdentifiers
//    }
//}

extension NSColor {

    var hexString: String {
        guard let rgbColor = usingColorSpaceName(NSColorSpaceName.calibratedRGB) else {
            return "#FFFFFF"
        }
        let red = Int(round(rgbColor.redComponent * 0xFF))
        let green = Int(round(rgbColor.greenComponent * 0xFF))
        let blue = Int(round(rgbColor.blueComponent * 0xFF))
        let hexString = NSString(format: "#%02X%02X%02X", red, green, blue)
        return hexString as String
    }
}
