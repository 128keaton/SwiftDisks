//
//  APFSVolume.swift
//  Shredder
//
//  Created by Keaton Burleson on 6/24/20.
//  Copyright © 2020 Pro Warehouse. All rights reserved.
//

import Foundation

// MARK: - RawAPFSVolume
public struct RawAPFSVolume: Codable, CustomStringConvertible {
    public let deviceIdentifier: String
    public let mountPoint, volumeName, volumeUUID: String?
    public let size: Int
    public let diskUUID, content: String?
    
    public var description: String {
        var base =  "-----APFSVolume-----\nSize: \(self.size)\nDevice ID: \(self.deviceIdentifier)\n"
        
        if let mountPoint = self.mountPoint {
            base += "Mount Point: \(mountPoint)\n"
        }
        
        if let volumeName = self.volumeName {
            base += "Volume Name: \(volumeName)\n"
        }
        
        if let volumeUUID = self.volumeUUID {
            base += "Volume UUID: \(volumeUUID)\n"
        }
        
        if let diskUUID = self.diskUUID {
            base += "Disk UUID: \(diskUUID)\n"
        }
        
        if let content = self.content {
            base += "Content: \(content)\n"
        }
        
        base += "-----APFSVolume-----\n\n"
        return base
    }

    enum CodingKeys: String, CodingKey {
        case deviceIdentifier = "DeviceIdentifier"
        case mountPoint = "MountPoint"
        case volumeName = "VolumeName"
        case volumeUUID = "VolumeUUID"
        case size = "Size"
        case diskUUID = "DiskUUID"
        case content = "Content"
    }
}
