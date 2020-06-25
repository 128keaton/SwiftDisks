//
//  DiskChangeInformation.swift
//  SwiftDisks
//
//  Created by Keaton Burleson on 6/25/20.
//  Copyright © 2020 Keaton Burleson. All rights reserved.
//

import Foundation

public enum DiskChangeType {
    case removal
    case mounted
}

public struct DiskChangeInformation {
    var changeType: DiskChangeType
    var mountPoint: String
    var volumeName: String
    var mountPointURL: URL?
}
