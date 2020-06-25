//
//  SwiftDisks+Notifications.swift
//  SwiftDisks
//
//  Created by Keaton Burleson on 6/25/20.
//  Copyright © 2020 Keaton Burleson. All rights reserved.
//

import Foundation
import AppKit

extension SwiftDisks {
    @objc func didMount(_ notification: NSNotification) {
        self.delegate?.disksChanged()
    }

    @objc func didUnmount(_ notification: NSNotification) {
        self.delegate?.disksChanged()
    }
    
    func registerSelfForNotifications() {
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(didMount(_:)), name: NSWorkspace.didMountNotification, object: nil)
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(didUnmount(_:)), name: NSWorkspace.didUnmountNotification, object: nil)
    }
}
