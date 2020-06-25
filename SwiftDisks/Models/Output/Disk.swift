//
//  Disk.swift
//  SwiftDisks
//
//  Created by Keaton Burleson on 6/24/20.
//  Copyright © 2020 Keaton Burleson. All rights reserved.
//

import Foundation

public class DiskNode: NSObject, Codable {
    public var type: DiskNodeType = .disk
    public var deviceID: String = ""
    public var content: String = ""
    public var size: Int = 0
    public var mountPoint: String = ""
    public var volumeName: String = ""
    public var physicalDisk: DiskNode? = nil
    
    @objc public dynamic var children = [ChildDiskNode]()

    public func isBootDrive() -> Bool {
        return isAPFS() && size >= 107374182400
    }

    public func isAPFS() -> Bool {
        let apfsPhysicalStore = self.children.first { (childDiskNode) -> Bool in
            return childDiskNode.type == .apfsPhysicalStore
        }

        return apfsPhysicalStore != nil
    }
    

}
