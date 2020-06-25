//
//  FormatEraseHelper.swift
//  SwiftDisks
//
//  Created by Keaton Burleson on 6/25/20.
//  Copyright © 2020 Keaton Burleson. All rights reserved.
//

import Foundation

class FormatEraseHelper {
    static func eraseDisk(_ disk: DiskNode, useAPFS: Bool = true, name: String? = nil, completion: @escaping (EraseResult) -> ()) {
        var newName: String = NameGenerator.getName()
        var diskIdentifier = disk.deviceID

        if let diskName = name {
            newName = diskName
        }

        if let physicalStore = disk.physicalDisk {
            diskIdentifier = physicalStore.deviceID
        }

        let format = useAPFS ? "APFS" : "JHFS+"
        let arguments = ["eraseDisk", format, newName, diskIdentifier]
        let command = "/usr/sbin/diskutil"

        TaskHelper.createTask(command: command, arguments: arguments) { (outputData, errorString) in
            var result = EraseResult(didSucceed: false, errorMessage: errorString, newVolumeName: nil, deviceIdentifier: nil)

            if let outputString = String(data: outputData, encoding: .utf8) {
                let lines = outputString.split(separator: "\n")
                guard let lastLine = lines.last else {
                    result.errorMessage = "No output from diskutil command"
                    completion(result)
                    return
                }

                if (String(lastLine).contains("Finished erase on \(diskIdentifier)")) {
                    result.didSucceed = true
                    result.deviceIdentifier = diskIdentifier
                    result.newVolumeName = newName
                }
            }

            completion(result)
        }
    }
}
