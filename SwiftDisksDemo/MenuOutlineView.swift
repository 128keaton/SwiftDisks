//
//  MenuOutlineView.swift
//  SwiftDisksDemo
//
//  Created by Keaton Burleson on 6/24/20.
//  Copyright © 2020 Keaton Burleson. All rights reserved.
//

import Foundation
import AppKit

protocol MenuOutlineViewDelegate: NSOutlineViewDelegate {
    func outlineView(outlineView: NSOutlineView, menuForItem item: AnyObject) -> NSMenu?
    func menuOpenedForItem(item: Any)
}

class MenuOutlineView: NSOutlineView {
    private (set) public var itemForActiveMenu: Any?

    override func menu(for event: NSEvent) -> NSMenu? {
        let point = self.convert(event.locationInWindow, from: nil)
        let row = self.row(at: point)
        let item = self.item(atRow: row)

        if (item == nil) {
            return nil
        }

        self.itemForActiveMenu = item

        if let menu = (self.delegate as! MenuOutlineViewDelegate).outlineView(outlineView: self, menuForItem: item as AnyObject) {
            menu.delegate = self
            return menu
        }

        return nil
    }

}


extension MenuOutlineView: NSMenuDelegate {
    func menuDidClose(_ menu: NSMenu) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.itemForActiveMenu = nil
        }
    }

    func menuWillOpen(_ menu: NSMenu) {
        (self.delegate as? MenuOutlineViewDelegate)?.menuOpenedForItem(item: self.itemForActiveMenu as Any)
    }
}
