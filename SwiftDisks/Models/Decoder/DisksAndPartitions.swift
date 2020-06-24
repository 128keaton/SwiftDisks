//
//  DisksAndPartitions.swift
//  Shredder
//
//  Created by Keaton Burleson on 6/24/20.
//  Copyright © 2020 Pro Warehouse. All rights reserved.
//

import Foundation

// MARK: - DisksAndPartitions
public struct DisksAndPartitions: Codable, CustomStringConvertible {
    public let partitions: [RawAPFSVolume]?
    public let content, deviceIdentifier: String
    public let size: Int
    public let apfsVolumes: [RawAPFSVolume]?
    public let apfsPhysicalStores: [APFSPhysicalStore]?
    public let mountPoint, volumeName: String?

    public var description: String {
        var base = "-----DisksAndPartitions-----\nSize: \(self.size)\n"

        if let mountPoint = self.mountPoint {
            base += "Mount Point: \(mountPoint)\n"
        }

        if let volumeName = self.volumeName {
            base += "Volume Name: \(volumeName)\n"
        }

        if let partitions = self.partitions {
            base += "Partitions:\n"
            partitions.forEach {
                base += "\n\($0)\n"
            }
        }

        if let apfsVolumes = self.apfsVolumes {
            base += "Volumes: \n"
            apfsVolumes.forEach {
                base += "\n\($0)\n"
            }
        }

        if let apfsPhysicalStores = self.apfsPhysicalStores {
            base += "APFS Physical Stores: \n"
            apfsPhysicalStores.forEach {
                base += "\n\($0)\n"
            }
        }

        base += "-----DisksAndPartitions-----\n\n"
        return base
    }

    enum CodingKeys: String, CodingKey {
        case partitions = "Partitions"
        case content = "Content"
        case deviceIdentifier = "DeviceIdentifier"
        case size = "Size"
        case apfsVolumes = "APFSVolumes"
        case apfsPhysicalStores = "APFSPhysicalStores"
        case mountPoint = "MountPoint"
        case volumeName = "VolumeName"
    }
}
