//
//  DiskNodeType.swift
//  SwiftDisks
//
//  Created by Keaton Burleson on 6/25/20.
//  Copyright © 2020 Keaton Burleson. All rights reserved.
//

import Foundation

public enum DiskNodeType: Int, Codable {
    case disk
    case apfsVolume
    case partition
    case apfsPhysicalStore
    case unknown
}
