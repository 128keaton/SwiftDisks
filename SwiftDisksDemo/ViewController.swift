//
//  ViewController.swift
//  SwiftDisksDemo
//
//  Created by Keaton Burleson on 6/24/20.
//  Copyright © 2020 Keaton Burleson. All rights reserved.
//

import Cocoa
import SwiftDisks

class ViewController: NSViewController {
    @IBOutlet var outlineView: MenuOutlineView?

    private var selectedDisk: DiskNode?
    private var lockedOverlay: NSView?
    private var afterFetch: () -> Void = { }

    var allDisks: [DiskNode] = [] {
        didSet {
            DispatchQueue.main.async {
                self.outlineView?.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        SwiftDisks.setDelegate(self)
        SwiftDisks.listenForDiskChanges()
        
        self.getAllDisks()
    }
    
    func getCachedDisks() {
        self.getAllDisks(lockUI: true, bypassCache: false)
    }

    func getAllDisks(lockUI: Bool = false, bypassCache: Bool = true) {
        if (lockUI) {
            self.lockUI()
        }

        SwiftDisks.getAllDisks(bypassCache: bypassCache) { (allDisks: [DiskNode]) in
            self.allDisks = allDisks
            DispatchQueue.main.async {
                self.unlockUI()
                self.afterFetch()
                self.afterFetch = {}
            }
        }
    }

    func lockUI(labelText: String? = nil) {
        if self.lockedOverlay != nil {
            return
        }

        self.lockedOverlay = LockedView(frame: self.view.frame)
        if let lockedOverlay = self.lockedOverlay {
            lockedOverlay.wantsLayer = true
            lockedOverlay.layer?.backgroundColor = CGColor.black.copy(alpha: 0.5)

            let spinnerX = (self.view.frame.width / 2) - 8
            let spinnerY = (self.view.frame.height / 2) - 8

            let spinner = NSProgressIndicator(frame: NSRect(x: spinnerX, y: spinnerY, width: 16, height: 16))
            spinner.style = .spinning
            spinner.isIndeterminate = true
            spinner.startAnimation(self)

            if let status = labelText {
                let labelX: CGFloat = 0.0
                let labelY = spinnerY - 36

                let label = NSTextField(frame: NSRect(x: labelX, y: labelY, width: self.view.frame.width, height: 20))
                label.stringValue = status
                label.isEditable = false
                label.isBordered = false
                label.alignment = .center
                label.drawsBackground = false
                label.textColor = .tertiaryLabelColor

                lockedOverlay.addSubview(label)
            }

            lockedOverlay.addSubview(spinner)
            lockedOverlay.alphaValue = 0.0
            self.view.addSubview(lockedOverlay, positioned: .above, relativeTo: self.outlineView)

            NSAnimationContext.runAnimationGroup { (context) in
                context.duration = 0.5
                lockedOverlay.animator().alphaValue = 1
            }
        }
    }

    func unlockUI() {
        if let lockedOverlay = self.lockedOverlay {
            NSAnimationContext.runAnimationGroup({ (context) in
                context.duration = 0.5
                lockedOverlay.animator().alphaValue = 0
            }) {
                lockedOverlay.removeFromSuperview()
                self.lockedOverlay = nil
            }
        }

        if let lockedOverlay = self.view.subviews.first(where: { (view) -> Bool in
            view.className == "LockedView"
        }) {
            NSAnimationContext.runAnimationGroup({ (context) in
                context.duration = 0.5
                lockedOverlay.animator().alphaValue = 0
            }) {
                lockedOverlay.removeFromSuperview()
                self.lockedOverlay = nil
            }
        }

    }

    private func ejectDisk(disk: DiskNode, force: Bool = false) {
        DispatchQueue.main.async {
            self.lockUI(labelText: "Ejecting disk '\(disk.deviceID)'")
            self.outlineView?.collapseItem(disk, collapseChildren: true)

            SwiftDisks.ejectDisk(disk, force: force) { (result) in
                DispatchQueue.main.async {
                    self.unlockUI()

                    if (!result.didSucceed), let errorMessage = result.errorMessage {
                        self.showErrorAlert(message: errorMessage)
                    }
                    
                    self.getAllDisks()
                }
            }
        }
    }

    private func eraseDisk(disk: DiskNode, useAPFS: Bool = true) {
        DispatchQueue.main.async {
            let response = self.showConfirmationAlert(message: "Are you sure you want to erase the disk '\(disk.deviceID)'? This cannot be undone.")
            if (response.rawValue == 1000) {
                self.lockUI(labelText: "Erasing disk '\(disk.deviceID)'")
                self.outlineView?.collapseItem(disk, collapseChildren: true)

                SwiftDisks.eraseDisk(disk, useAPFS: useAPFS) { (result) in
                    DispatchQueue.main.async {
                        self.unlockUI()

                        if (!result.didSucceed), let errorMessage = result.errorMessage {
                            self.showErrorAlert(message: errorMessage)
                        } else if let newVolumeName = result.newVolumeName {
                            self.getAllDisks()
                            self.afterFetch = { self.expandFor(volumeName: newVolumeName) }
                        }
                    }
                }
            }
        }
    }

    @objc func eraseDiskAPFS() {
        if let disk = self.outlineView?.itemForActiveMenu as? DiskNode {
            self.eraseDisk(disk: disk)
        }
    }

    @objc func eraseDiskHFS() {
        if let disk = self.outlineView?.itemForActiveMenu as? DiskNode {
            self.eraseDisk(disk: disk, useAPFS: false)
        }
    }

    @objc func ejectDiskGently() {
        if let disk = self.outlineView?.itemForActiveMenu as? DiskNode {
            self.ejectDisk(disk: disk, force: false)
        }
    }

    @objc func ejectDiskForce() {
        if let disk = self.outlineView?.itemForActiveMenu as? DiskNode {
            self.ejectDisk(disk: disk, force: true)
        }
    }

    func expandFor(volumeName: String) {
        var disk: DiskNode? = self.allDisks.first {
            $0.volumeName == volumeName
        }

        if (disk == nil) {
            disk = self.allDisks.first {
                let childDiskNode = $0.children.first {
                    $0.volumeName == volumeName
                }

                return childDiskNode != nil
            }
        }

        guard let expandDisk = disk else {
            return
        }

        self.outlineView?.expandItem(expandDisk, expandChildren: true)
    }

    func showErrorAlert(message: String) {
        let alert = NSAlert()
        alert.alertStyle = .critical
        alert.messageText = "Error"
        alert.informativeText = message

        alert.runModal()
    }

    func showConfirmationAlert(message: String) -> NSApplication.ModalResponse {
        let alert = NSAlert()
        alert.alertStyle = .warning
        alert.messageText = "Confirm Erase"
        alert.informativeText = message

        alert.addButton(withTitle: "Yes")
        alert.addButton(withTitle: "No")

        return alert.runModal()
    }
}

extension ViewController: SwiftDisksDelegate {
    func disksChanged(_ information: DiskChangeInformation) {
        if (information.changeType == .mounted), let mountPointURL = information.mountPointURL {
            NSWorkspace.shared.open(mountPointURL)
        }
        
        if (self.lockedOverlay == nil) {
            self.getAllDisks(lockUI: true)
        }
    }
}

extension ViewController: MenuOutlineViewDelegate {
    func menuOpenedForItem(item: Any) {
        if let item = item as? DiskNode {
            self.outlineView?.expandItem(item, expandChildren: true)
        }
    }

    func outlineView(outlineView: NSOutlineView, menuForItem item: AnyObject) -> NSMenu? {
        var menu: NSMenu? = nil

        if let item = item as? DiskNode {
            menu = NSMenu(title: "Disk\(item.isBootDrive() ? " (Bootable)" : "")")
            menu?.addItem(withTitle: menu!.title, action: nil, keyEquivalent: "")
            menu?.addItem(withTitle: "Device ID: \(item.deviceID)", action: nil, keyEquivalent: "")
            menu?.addItem(withTitle: "Size: \(item.size)", action: nil, keyEquivalent: "")
            menu?.addItem(withTitle: "Content: \(item.content)", action: nil, keyEquivalent: "")
            menu?.addItem(withTitle: "Mount Point: \(item.mountPoint)", action: nil, keyEquivalent: "")
            menu?.addItem(withTitle: "Volume Name: \(item.volumeName)", action: nil, keyEquivalent: "")
            if let physicalDisk = item.physicalDisk {
                menu?.addItem(withTitle: "Physical Disk: \(physicalDisk.deviceID)", action: nil, keyEquivalent: "")
            }

            menu?.addItem(withTitle: "Erase (APFS)", action: #selector(eraseDiskAPFS), keyEquivalent: "")
            menu?.addItem(withTitle: "Erase (JHFS+)", action: #selector(eraseDiskHFS), keyEquivalent: "")
            menu?.addItem(withTitle: "Eject", action: #selector(ejectDiskGently), keyEquivalent: "")
            menu?.addItem(withTitle: "Eject (force)", action: #selector(ejectDiskForce), keyEquivalent: "")

        } else if let item = item as? APFSVolumeNode {
            menu = NSMenu(title: "APFS Volume")
            menu?.addItem(withTitle: menu!.title, action: nil, keyEquivalent: "")
            menu?.addItem(withTitle: "Device ID: \(item.deviceID)", action: nil, keyEquivalent: "")
            menu?.addItem(withTitle: "Size: \(item.size)", action: nil, keyEquivalent: "")
            menu?.addItem(withTitle: "Mount Point: \(item.mountPoint)", action: nil, keyEquivalent: "")
            menu?.addItem(withTitle: "Volume Name: \(item.volumeName)", action: nil, keyEquivalent: "")
        } else if let item = item as? APFSPhysicalStoreNode {
            menu = NSMenu(title: "APFS Physical Store")
            menu?.addItem(withTitle: menu!.title, action: nil, keyEquivalent: "")
            menu?.addItem(withTitle: "Device ID: \(item.deviceID)", action: nil, keyEquivalent: "")
        }

        return menu
    }
}

extension ViewController: NSOutlineViewDelegate, NSOutlineViewDataSource {
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if let diskNode = item as? DiskNode {
            return diskNode.children.count
        }

        return self.allDisks.count
    }

    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let diskNode = item as? DiskNode {
            return diskNode.children[index]
        }

        return self.allDisks[index]
    }

    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if let diskNode = item as? DiskNode {
            return diskNode.children.count > 0
        }

        return false
    }

    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        var view: NSTableCellView?

        if let diskNode = item as? DiskNode {
            view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "DiskCell"), owner: self) as? NSTableCellView
            if let textField = view?.textField {
                textField.stringValue = diskNode.deviceID
                textField.sizeToFit()
            }
        } else if let childNode = item as? ChildDiskNode {
            view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ChildCell"), owner: self) as? NSTableCellView
            var value = "Volume Name - \(childNode.volumeName)"

            if (childNode.type == .apfsPhysicalStore) {
                value = "Physical Store - \(childNode.deviceID)"
            }

            if let textField = view?.textField {
                textField.stringValue = value
                textField.sizeToFit()
            }
        }

        return view
    }
}

class LockedView: NSView {
}
