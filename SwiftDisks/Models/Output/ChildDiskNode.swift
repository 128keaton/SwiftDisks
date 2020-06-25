//
//  DiskChildNode.swift
//  SwiftDisks
//
//  Created by Keaton Burleson on 6/25/20.
//  Copyright © 2020 Keaton Burleson. All rights reserved.
//

import Foundation

public class ChildDiskNode: NSObject, Codable {
    public var size: Int = 0
    public var deviceID: String = ""
    public var mountPoint: String = ""
    public var volumeName: String = ""
    public var type: DiskNodeType = .unknown
}
