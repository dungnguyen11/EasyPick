//
//  User.swift
//  EasyPick
//
//  Created by Dung Nguyen on 1/8/18.
//  Copyright © 2018 Dung Nguyen - s3598776. All rights reserved.
//

import Foundation

class RoomUser {
    var id: String?
    var name: String?
    var currentNumber: Int?
    var currentRoomId: String?
    
    init(name: String) {
        self.id = NSUUID().uuidString
        self.name = name
        self.currentNumber = 0
        self.currentRoomId = nil
    }
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
        self.currentNumber = 0
        self.currentRoomId = nil
    }
}
