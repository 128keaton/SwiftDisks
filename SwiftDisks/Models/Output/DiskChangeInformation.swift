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
    /// Change type of the disk change. Will either me 'removal' or 'mounted'
    public var changeType: DiskChangeType

    /// Mount point that was mounted or removed
    public var mountPoint: String

    /// Volume name that was mounted or removed
    public var volumeName: String

    /// URL to volume that was mounted or removed
    public var mountPointURL: URL?
}
