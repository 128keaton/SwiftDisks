//
//  SwiftDisks.swift
//  SwiftDisks
//
//  Created by Keaton Burleson on 6/24/20.
//  Copyright © 2020 Keaton Burleson. All rights reserved.
//

import Foundation
import AppKit

public class SwiftDisks {
    private static var instance: SwiftDisks?
    private static let cache = ExpiringCache()

    var delegate: SwiftDisksDelegate?


    public static var safeMode: Bool = true {
        didSet {
            print("\(self.safeMode ? "Enabling" : "Disabling") Safe Mode")
        }
    }

    /// Set the delegate for disk notifications
    public static func setDelegate(_ delegate: SwiftDisksDelegate) {
        if (self.instance == nil) {
            self.instance = SwiftDisks()
        }

        self.instance?.delegate = delegate
    }

    /// Listen for disk eject/unmount and mount
    public static func listenForDiskChanges() {
        if (self.instance == nil) {
            self.instance = SwiftDisks()
        }

        self.instance?.registerSelfForNotifications()
    }

    /// Get all disks cached
    public static func getAllCachedDisks(callback: @escaping ([DiskNode]) -> ()) {
        if let cachedDisks = self.cache.object(forKey: "cachedDisks" as AnyObject) as? NSArray {
            callback(cachedDisks as! [DiskNode])
            return
        } else {
            self.getAllDisks(bypassCache: true) { (allDisks) in
                callback(allDisks)
                self.cache.setObject(allDisks as AnyObject, forKey: "cachedDisks" as AnyObject)
            }
        }
    }
    
    private static func getScriptPath() -> String {
        let localBundle = Bundle(for: self)
        
        print(localBundle.bundlePath)
        if let bundleURL = localBundle.url(forResource: "SwiftDisks", withExtension: "bundle"),
            let bundle = Bundle(url: bundleURL) {
            return "\(bundle.resourcePath!)/list-disks-json.sh"
        } else if let resourcePath = localBundle.resourcePath {
            return "\(resourcePath)/list-disks-json.sh"
        }
        
        return ""
    }

    /// Get all disks available with a callback
    public static func getAllDisks(bypassCache: Bool = true, _ callback: @escaping ([DiskNode]) -> ()) {
        let scriptPath = getScriptPath()
        var allDisks: [DiskNode] = []
        
        if (!bypassCache), let cachedDisks = self.cache.object(forKey: "cachedDisks" as AnyObject) as? NSArray {
            allDisks = cachedDisks as! [DiskNode]
            callback(allDisks)
            return
        }
        

        TaskHelper.createTask(command: "/bin/bash", arguments: [scriptPath]) { (jsonData, error) in
            do {
                let listDisks = try JSONDecoder().decode(DiskList.self, from: jsonData)
                allDisks = mapDisks(listDisks.allDisksAndPartitions)
                callback(allDisks)
            } catch {
                print("Error parsing Disk Utility output: \(error.localizedDescription)")
                callback(allDisks)
            }
            self.cache.setObject(allDisks as AnyObject, forKey: "cachedDisks" as AnyObject)

        }

    }

    /// Erase Disk
    public static func eraseDisk(_ disk: DiskNode, useAPFS: Bool = true, name: String? = nil, completion: @escaping (EraseResult) -> ()) {
        if ((disk.isBootDrive() || disk.mountPoint == "/") && self.safeMode) {
            print("This is the root drive or a boot drive and safe mode is enabled. Cannot erase.")
            return
        }

        FormatEraseHelper.eraseDisk(disk, useAPFS: useAPFS, name: name, completion: completion)
    }

    /// Eject Disk
    public static func ejectDisk(_ disk: DiskNode, force: Bool = false, completion: @escaping (EjectResult) -> ()) {
        if ((disk.isBootDrive() || disk.mountPoint == "/") && self.safeMode) {
            print("This is the root drive or a boot drive and safe mode is enabled. Cannot eject.")
            return
        }

        EjectUnmountHelper.ejectDisk(disk, force: force, completion: completion)
    }

    /// Map DisksAndPartitions to DiskNode array
    private static func mapDisks(_ allDisksAndPartitions: [DisksAndPartitions]) -> [DiskNode] {
        let allDisks: [DiskNode] = allDisksAndPartitions.map {
            let node = DiskNode()
            node.deviceID = $0.deviceIdentifier
            node.size = $0.size
            node.content = $0.content
            node.mountPoint = $0.mountPoint ?? "None"
            node.volumeName = $0.volumeName ?? "None"

            if let apfsVolumes = $0.apfsVolumes {
                let mappedVolumes: [ChildDiskNode] = apfsVolumes.map {
                    let apfsVolumeNode = APFSVolumeNode()
                    apfsVolumeNode.setAPFSVolumeInfo(info: $0)
                    return apfsVolumeNode
                }

                node.children.append(contentsOf: mappedVolumes)
            }

            if let partitions = $0.partitions {
                let mappedVolumes: [ChildDiskNode] = partitions.map {
                    let apfsVolumeNode = APFSVolumeNode()
                    apfsVolumeNode.setAPFSVolumeInfo(info: $0)
                    return apfsVolumeNode
                }

                node.children.append(contentsOf: mappedVolumes)
            }

            if let apfsPhysicalStores = $0.apfsPhysicalStores {
                let mappedStores: [ChildDiskNode] = apfsPhysicalStores.map {
                    let apfsPhysicalStoreNode = APFSPhysicalStoreNode()
                    apfsPhysicalStoreNode.setPhysicalStoreInfo(info: $0)
                    return apfsPhysicalStoreNode
                }

                node.children.append(contentsOf: mappedStores)
            }

            return node
        }

        return allDisks.map {
            if let physicalStore = $0.children.first(where: { (childDiskNode) -> Bool in
                return childDiskNode.type == .apfsPhysicalStore
            }) as? APFSPhysicalStoreNode {
                let physicalDiskID = getRootDisk(fromDeviceIdentifier: physicalStore.deviceID)

                if let physicalDisk = allDisks.first(where: { (disk) -> Bool in
                    disk.deviceID == physicalDiskID
                }) {
                    $0.physicalDisk = physicalDisk
                }
            }

            return $0
        }
    }


    /// Splits partition ID from disk ID (disk0s1 becomes disk0)
    private static func getRootDisk(fromDeviceIdentifier deviceIdentifier: String) -> String {
        var rootDiskID = deviceIdentifier

        if let regex = try? NSRegularExpression(pattern: "s[0-9].*", options: .caseInsensitive) {
            let range = NSRange(location: 0, length: deviceIdentifier.count)
            rootDiskID = regex.stringByReplacingMatches(in: deviceIdentifier, options: [], range: range, withTemplate: "")
        }

        return rootDiskID
    }
}
