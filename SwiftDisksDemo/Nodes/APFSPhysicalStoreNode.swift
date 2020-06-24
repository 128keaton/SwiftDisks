//
//  APFSPhysicalStoreNode.swift
//  SwiftDisksDemo
//
//  Created by Keaton Burleson on 6/24/20.
//  Copyright © 2020 Keaton Burleson. All rights reserved.
//

import Foundation
import SwiftDisks

class APFSPhysicalStoreNode: ChildNode {
    func setPhysicalStoreInfo(info: APFSPhysicalStore) {
        self.deviceID = info.deviceIdentifier
        self.type = .apfsPhysicalStore
    }
}
