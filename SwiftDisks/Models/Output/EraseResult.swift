//
//  EraseResult.swift
//  SwiftDisks
//
//  Created by Keaton Burleson on 6/25/20.
//  Copyright © 2020 Keaton Burleson. All rights reserved.
//

import Foundation

public struct EraseResult {
    public var didSucceed: Bool
    public var errorMessage: String?
    public var newVolumeName: String?
    public var deviceIdentifier: String?
}
