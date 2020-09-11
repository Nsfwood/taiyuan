//
//  ViewController.swift
//  taiyuan
//
//  Created by Alexander Rohrig on 9/10/20.
//

import Cocoa
import Foundation

class ViewController: NSViewController {
    
    var bookmarks = [URL: Data]()
    var lists = NSColorList.availableColorLists
    var listIndex = 0
    var rgbIs8Bit = true

    @IBOutlet weak var colorListPicker: NSPopUpButton!
    @IBOutlet weak var tableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        NSLocalizedString("Delete Color", comment: "")
        
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: NSLocalizedString("Copy Color as HEX", comment: ""), action: #selector(tableViewCopyHEXClicked(_:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: NSLocalizedString("Copy Color as RGB", comment: ""), action: #selector(tableViewCopyRGBClicked(_:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: NSLocalizedString("Add Color Below", comment: ""), action: #selector(tableViewAddClicked(_:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: NSLocalizedString("Rename Color", comment: ""), action: #selector(tableViewRenameClicked(_:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: NSLocalizedString("Delete Color", comment: ""), action: #selector(tableViewDeleteClicked(_:)), keyEquivalent: ""))
        
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
        listIndex = colorListPicker.indexOfSelectedItem
        print(l)
        let keys = l.allKeys
        print(keys)
        tableView.reloadData()
    }
    
    @IBAction func colorPickerPressed(_ sender: Any) {
        NSApplication.shared.orderFrontColorPanel(self)
    }
    
    @objc private func tableViewCopyHEXClicked(_ sender: AnyObject) {
        
    }
    
    @objc private func tableViewCopyRGBClicked(_ sender: AnyObject) {
        
    }
    
    @objc private func tableViewAddClicked(_ sender: AnyObject) {
        
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
                        if rgbIs8Bit {
                            view.textField?.stringValue = "\(Int(round(r*255))), \(Int(round(g*255))), \(Int(round(b*255)))"
                        }
                        else {
                            view.textField?.stringValue = "\(r), \(g), \(b)"
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
