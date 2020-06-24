//
//  ChildNode.swift
//  SwiftDisksDemo
//
//  Created by Keaton Burleson on 6/24/20.
//  Copyright © 2020 Keaton Burleson. All rights reserved.
//

import Foundation
import SwiftDisks

class ChildNode: NSObject, Codable {
    var size: Int = 0
    var deviceID: String = ""
    var mountPoint: String = ""
    var volumeName: String = ""
    var type: NodeType = .unknown
}
