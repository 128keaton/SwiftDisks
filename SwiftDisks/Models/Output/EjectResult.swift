//
//  EjectResult.swift
//  SwiftDisks
//
//  Created by Keaton Burleson on 6/25/20.
//  Copyright © 2020 Keaton Burleson. All rights reserved.
//

import Foundation

public struct EjectResult {
    public var didSucceed: Bool
    public var errorMessage: String?
    public var deviceIdentifier: String?
}
