//
//  APFSPhysicalStoreNode.swift
//  SwiftDisks
//
//  Created by Keaton Burleson on 6/25/20.
//  Copyright © 2020 Keaton Burleson. All rights reserved.
//

import Foundation

public class APFSPhysicalStoreNode: ChildDiskNode {
    func setPhysicalStoreInfo(info: APFSPhysicalStore) {
        self.deviceID = info.deviceIdentifier
        self.type = .apfsPhysicalStore
    }
}
