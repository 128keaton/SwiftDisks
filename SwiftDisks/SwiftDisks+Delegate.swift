//
//  SwiftDisks+Delegate.swift
//  SwiftDisks
//
//  Created by Keaton Burleson on 6/25/20.
//  Copyright © 2020 Keaton Burleson. All rights reserved.
//

import Foundation

public protocol SwiftDisksDelegate {
    func disksChanged(_ information: DiskChangeInformation)
}
