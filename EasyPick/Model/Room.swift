//
//  Room.swift
//  EasyPick
//
//  Created by Dung Nguyen on 1/8/18.
//  Copyright © 2018 Dung Nguyen - s3598776. All rights reserved.
//

import Foundation

class Room : NSObject {
    var id: String?
    var name: String?
    var currentNumber: Int?
    var creatorId: String?
    var totalUsers: Int?
    
    override init() {
        self.id = NSUUID().uuidString
        self.name = nil
        self.creatorId = nil
        self.currentNumber = 0
        self.totalUsers = 0
    }
    
    init(name: String, creatorId: String) {
        self.id = NSUUID().uuidString
        self.name = name
        self.creatorId = creatorId
        self.currentNumber = 0
        self.totalUsers = 0
    }
    
    init(id: String, name: String, creatorId: String, currentNumber: Int, totalUsers: Int?) {
        self.id = id
        self.name = name
        self.creatorId = creatorId
        self.currentNumber = currentNumber
        self.totalUsers = totalUsers
    }
    
}
