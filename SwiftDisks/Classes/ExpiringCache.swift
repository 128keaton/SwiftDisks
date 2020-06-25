//
//  ExpiringCache.swift
//  SwiftDisks
//
//  Created by Keaton Burleson on 6/25/20.
//  Copyright © 2020 Keaton Burleson. All rights reserved.
//

import Foundation

class ExpiringCache : NSCache<AnyObject, AnyObject> {

    private let ExpiringCacheObjectKey = "ExpiringCache"
    private let ExpiringCacheDefaultTimeout: TimeInterval = 60
    
    /// Add item to queue and manually set timeout
    ///
    /// - parameter obj: Object to be saved
    /// - parameter key: Key of object to be saved
    /// - parameter timeout: In how many seconds should the item be removed

    func setObject(obj: AnyObject, forKey key: AnyObject, timeout: TimeInterval) {
        super.setObject(obj, forKey: key)
        Timer.scheduledTimer(timeInterval: timeout, target: self, selector: #selector(timerExpires(timer:)), userInfo: [ExpiringCacheObjectKey : key], repeats: false)
    }

    // Override default `setObject` to use some default timeout interval

    override func setObject(_ obj: AnyObject, forKey key: AnyObject) {
        setObject(obj: obj, forKey: key, timeout: ExpiringCacheDefaultTimeout)
    }

    // method to remove item from cache

    @objc func timerExpires(timer: Timer) {
        if let userInfo = timer.userInfo as? NSDictionary {
            removeObject(forKey: userInfo[ExpiringCacheObjectKey] as! String as AnyObject)
        }
    }
}
