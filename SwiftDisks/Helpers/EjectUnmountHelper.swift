//
//  EjectUnmountHelper.swift
//  SwiftDisks
//
//  Created by Keaton Burleson on 6/25/20.
//  Copyright © 2020 Keaton Burleson. All rights reserved.
//

import Foundation

class EjectUnmountHelper {
    static func ejectDisk(_ disk: DiskNode, force: Bool = false, completion: @escaping (EjectResult) -> ()) {
        var diskIdentifier = disk.deviceID

        if let physicalStore = disk.physicalDisk, !force {
            diskIdentifier = physicalStore.deviceID
        }

       
        var arguments = ["eject", diskIdentifier]
        
        if (force) {
            arguments = ["unmountDisk", "force", diskIdentifier]
        }
        
        let command = "/usr/sbin/diskutil"

        TaskHelper.createTask(command: command, arguments: arguments) { (outputData, errorString) in
            var result = EjectResult(didSucceed: false, errorMessage: errorString, deviceIdentifier: nil)

            if let outputString = String(data: outputData, encoding: .utf8) {
                let lines = outputString.split(separator: "\n")
                guard let lastLine = lines.last else {
                    result.errorMessage = "No output from diskutil command"
                    completion(result)
                    return
                }

                if (String(lastLine).contains("Disk \(diskIdentifier) ejected")), !force {
                    result.didSucceed = true
                    result.deviceIdentifier = diskIdentifier
                } else if (String(lastLine).contains("Forced unmount of all volumes on \(diskIdentifier) was successful")), force {
                    result.didSucceed = true
                    result.deviceIdentifier = diskIdentifier
                }
            }

            completion(result)
        }
    }
}
