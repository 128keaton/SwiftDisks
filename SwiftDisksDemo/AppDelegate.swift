//
//  AppDelegate.swift
//  SwiftDisksDemo
//
//  Created by Keaton Burleson on 6/24/20.
//  Copyright © 2020 Keaton Burleson. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    private var viewController: ViewController?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        if let window = NSApp.mainWindow,
            let viewController = window.contentViewController as? ViewController {
            self.viewController = viewController
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func reloadDisks(_ sender: NSMenuItem) {
        if let viewController = self.viewController {
            viewController.getAllDisks(lockUI: true)
        }
    }

}

