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
}

class MenuOutlineView: NSOutlineView {

    override func menu(for event: NSEvent) -> NSMenu? {
        let point = self.convert(event.locationInWindow, from: nil)
        let row = self.row(at: point)
        let item = self.item(atRow: row)

        if (item == nil) {
            return nil
        }

        return (self.delegate as! MenuOutlineViewDelegate).outlineView(outlineView: self, menuForItem: item as AnyObject)
    }

}
