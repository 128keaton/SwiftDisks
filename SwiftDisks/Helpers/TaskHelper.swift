//
//  TaskHelper.swift
//  SwiftDisks
//
//  Created by Keaton Burleson on 6/25/20.
//  Copyright © 2020 Keaton Burleson. All rights reserved.
//

import Foundation

class TaskHelper {
    /// Create NSTask
    static func createTask(command: String, arguments: [String], callback: @escaping (Data, String?) -> ()) {
        let task = Process()
        let errorPipe = Pipe()
        let standardPipe = Pipe()

        task.standardError = errorPipe
        task.standardOutput = standardPipe

        task.launchPath = command
        task.arguments = arguments

        task.terminationHandler = { (process) in
            if(process.isRunning == false) {
                let standardHandle = standardPipe.fileHandleForReading
                let standardData = standardHandle.readDataToEndOfFile()

                let errorHandle = errorPipe.fileHandleForReading
                let errorData = errorHandle.readDataToEndOfFile()
                let taskErrorOutput = String (data: errorData, encoding: String.Encoding.utf8)

                callback(standardData, taskErrorOutput)
            }
        }

        task.launch()
    }

}
