//
//  APFSVolumeNode.swift
//  SwiftDisks
//
//  Created by Keaton Burleson on 6/25/20.
//  Copyright © 2020 Keaton Burleson. All rights reserved.
//

import Foundation

public class APFSVolumeNode: ChildDiskNode {
    func setAPFSVolumeInfo(info: RawAPFSVolume) {
        self.size = info.size
        self.mountPoint = info.mountPoint ?? "No Mount Point"
        self.volumeName = info.volumeName ?? "No Name"
        self.deviceID = info.deviceIdentifier
        self.type = .apfsVolume
    }
}
