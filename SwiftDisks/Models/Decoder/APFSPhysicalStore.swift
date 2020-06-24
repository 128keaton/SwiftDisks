//
//  APFSPhysicalStore.swift
//  Shredder
//
//  Created by Keaton Burleson on 6/24/20.
//  Copyright © 2020 Pro Warehouse. All rights reserved.
//

import Foundation

// MARK: - APFSPhysicalStore
public struct APFSPhysicalStore: Codable, CustomStringConvertible {
    public let deviceIdentifier: String

    public var description: String {
        return "-----APFSPhysicalStore-----\nDevice Identifier: \(self.deviceIdentifier)\n-----APFSPhysicalStore-----\n\n"
    }
    
    enum CodingKeys: String, CodingKey {
        case deviceIdentifier = "DeviceIdentifier"
    }
}
