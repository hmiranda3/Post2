//
//  Post.swift
//  Post2
//
//  Created by Habib Miranda on 6/2/16.
//  Copyright © 2016 littleJohns. All rights reserved.
//

import Foundation

struct Post {
    
    private let kUsername = "username"
    private let kText = "text"
    private let kTimestamp = "timestamp"
    private let kUUID = "uuid"
    
    let username: String
    let text: String
    let timestamp: NSTimeInterval
    let identifier: NSUUID
    
    init(username: String, text: String) {
        
        self.username = username
        self.text = text
        self.identifier = NSUUID()
        self.timestamp = NSDate().timeIntervalSince1970
    }
    
    var queryTimestamp: NSTimeInterval {
        return timestamp - 0.000001
    }
    
    init?(dictionary: [String:AnyObject], identifier: String) {
        guard let username = dictionary[kUsername] as? String,
            let text = dictionary[kText] as? String,
            let timestamp = dictionary[kTimestamp] as? Double,
            let identifier = NSUUID(UUIDString: identifier) else {
            return nil
        }
        self.username = username
        self.text = text
        self.timestamp = timestamp
        self.identifier = identifier
    }
}