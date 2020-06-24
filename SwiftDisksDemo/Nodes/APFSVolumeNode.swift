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
        self.mountPoint = info.mountPoint ?? "(not mounted)"
        self.volumeName = info.volumeName ?? "(no name)"
        self.deviceID = info.deviceIdentifier
        self.type = .apfsVolume
    }
}
