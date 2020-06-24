//
//  DiskList.swift
//  Shredder
//
//  Created by Keaton Burleson on 6/24/20.
//  Copyright © 2020 Pro Warehouse. All rights reserved.
//

import Foundation

// MARK: - ListDisks
public struct DiskList: Codable, CustomStringConvertible {
    public let allDisksAndPartitions: [DisksAndPartitions]
    public let volumesFromDisks, allDisks, wholeDisks: [String]

    public var description: String {
        var base = "-----DiskList-----\n"

        allDisksAndPartitions.forEach {
            base += "\($0)\n"
        }

        volumesFromDisks.forEach {
            base += "\($0)\n"
        }

        allDisks.forEach {
            base += "\($0)\n"
        }

        wholeDisks.forEach {
            base += "\($0)\n"
        }

        base += "-----DiskList-----\n\n"
        return base
    }

    enum CodingKeys: String, CodingKey {
        case allDisksAndPartitions = "AllDisksAndPartitions"
        case volumesFromDisks = "VolumesFromDisks"
        case allDisks = "AllDisks"
        case wholeDisks = "WholeDisks"
    }
}
