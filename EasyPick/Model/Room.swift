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
    var creator: Attendant?
    
    override init() {
        self.id = NSUUID().uuidString
        self.name = nil
        self.creator = nil
        self.currentNumber = 0
    }
    
    init(name: String, creator: Attendant) {
        self.id = NSUUID().uuidString
        self.name = name
        self.creator = creator
        self.currentNumber = 0
    }
    
    init(id: String, name: String, creator: Attendant?, currentNumber: Int) {
        self.id = id
        self.name = name
        self.creator = creator
        self.currentNumber = currentNumber
    }
    
}
