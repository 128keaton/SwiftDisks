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
        var information = DiskChangeInformation(changeType: .mounted, mountPoint: "", volumeName: "", mountPointURL: nil)
        if let userInfo = notification.userInfo {
            if let mountPoint = userInfo["NSDevicePath"] as? String {
                information.mountPoint = mountPoint
            }

            if let volumeName = userInfo["NSWorkspaceVolumeLocalizedNameKey"] as? String {
                information.volumeName = volumeName
            }

            if let mountPointURL = userInfo["NSWorkspaceVolumeURLKey"] as? NSURL {
                information.mountPointURL = mountPointURL as URL
            }
        }

        self.delegate?.disksChanged(information)
    }

    @objc func didUnmount(_ notification: NSNotification) {
        var information = DiskChangeInformation(changeType: .removal, mountPoint: "", volumeName: "", mountPointURL: nil)
        if let userInfo = notification.userInfo {
            if let mountPoint = userInfo["NSDevicePath"] as? String {
                information.mountPoint = mountPoint
            }

            if let volumeName = userInfo["NSWorkspaceVolumeLocalizedNameKey"] as? String {
                information.volumeName = volumeName
            }

            if let mountPointURL = userInfo["NSWorkspaceVolumeURLKey"] as? NSURL {
                information.mountPointURL = mountPointURL as URL
            }
        }

        self.delegate?.disksChanged(information)
    }

    func registerSelfForNotifications() {
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(didMount(_:)), name: NSWorkspace.didMountNotification, object: nil)
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(didUnmount(_:)), name: NSWorkspace.didUnmountNotification, object: nil)
    }
}
