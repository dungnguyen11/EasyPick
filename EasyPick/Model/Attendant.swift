//
//  User.swift
//  EasyPick
//
//  Created by Dung Nguyen on 1/8/18.
//  Copyright © 2018 Dung Nguyen - s3598776. All rights reserved.
//

import Foundation

class Attendant {
    var id: String?
    var name: String?
    var myCurrentNumber: Int?
    var myCurrentRoom: Room?
    var isAdmin: Bool?
    var rooms: [Room]?
    
    init(name: String) {
        self.id = NSUUID().uuidString
        self.name = name
        self.myCurrentNumber = 0
        self.myCurrentRoom = nil
        self.isAdmin = false
        self.rooms = []
    }
}
