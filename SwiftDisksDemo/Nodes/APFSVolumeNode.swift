//
//  APFSVolumeNode.swift
//  SwiftDisksDemo
//
//  Created by Keaton Burleson on 6/24/20.
//  Copyright © 2020 Keaton Burleson. All rights reserved.
//

import Foundation
import SwiftDisks

class APFSVolumeNode: ChildNode {
    func setAPFSVolumeInfo(info: RawAPFSVolume) {
        self.size = info.size
        self.mountPoint = info.mountPoint ?? "No Mount Point"
        self.volumeName = info.volumeName ?? "No Name"
        self.deviceID = info.deviceIdentifier
        self.type = .apfsVolume
    }
}
