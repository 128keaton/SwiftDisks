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
    @IBOutlet var outlineView: NSOutlineView?

    var nodes: [DiskNode] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        SwiftDisks.getAllDisks { (allDisks: [DisksAndPartitions]) in
            let diskNodes: [DiskNode] = allDisks.map {
                let node = DiskNode()
                node.deviceID = $0.deviceIdentifier

                if let apfsVolumes = $0.apfsVolumes {
                    let mappedVolumes: [ChildNode] = apfsVolumes.map {
                        let apfsVolumeNode = APFSVolumeNode()
                        apfsVolumeNode.setAPFSVolumeInfo(info: $0)
                        return apfsVolumeNode
                    }

                    node.children.append(contentsOf: mappedVolumes)
                }

                if let apfsPhysicalStores = $0.apfsPhysicalStores {
                    let mappedStores: [ChildNode] = apfsPhysicalStores.map {
                        let apfsPhysicalStoreNode = APFSPhysicalStoreNode()
                        apfsPhysicalStoreNode.setPhysicalStoreInfo(info: $0)
                        return apfsPhysicalStoreNode
                    }

                    node.children.append(contentsOf: mappedStores)
                }

                return node
            }

            self.nodes = diskNodes

            DispatchQueue.main.async {
                self.outlineView?.reloadData()
            }
        }


    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }


}


extension ViewController: NSOutlineViewDelegate, NSOutlineViewDataSource {
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if let diskNode = item as? DiskNode {
            return diskNode.children.count
        }

        return nodes.count
    }

    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let diskNode = item as? DiskNode {
            return diskNode.children[index]
        }

        return nodes[index]
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
        } else if let childNode = item as? ChildNode {
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
