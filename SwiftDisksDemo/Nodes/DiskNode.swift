//
//  DiskNode.swift
//  SwiftDisksDemo
//
//  Created by Keaton Burleson on 6/24/20.
//  Copyright © 2020 Keaton Burleson. All rights reserved.
//

import Foundation

enum NodeType: Int, Codable {
    case disk
    case apfsVolume
    case partition
    case apfsPhysicalStore
    case unknown
}

class DiskNode: NSObject, Codable {
    var type: NodeType = .disk
    var deviceID: String = ""
    var content: String = ""
    var size: Int = 0
    var mountPoint: String = ""
    var volumeName: String = ""
    @objc dynamic var children = [ChildNode]()
}
