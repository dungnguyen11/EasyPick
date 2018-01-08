//
//  Room.swift
//  EasyPick
//
//  Created by Dung Nguyen on 1/8/18.
//  Copyright © 2018 Dung Nguyen - s3598776. All rights reserved.
//

import Foundation

class Room {
    var id: String?
    var name: String?
    var currentNumber: Int?
    var creator: Attendant?
    
    init(name: String, creator: Attendant) {
        self.id = NSUUID().uuidString
        self.name = name
        self.creator = creator
        self.currentNumber = 0
    }
    
}
