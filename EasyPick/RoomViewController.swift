//
//  RoomViewController.swift
//  EasyPick
//
//  Created by Dung Nguyen on 1/14/18.
//  Copyright © 2018 Dung Nguyen - s3598776. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI

class RoomViewController: UIViewController {
    
    //Firebase
    var room: Room?
    var currentUser = Auth.auth().currentUser
    var roomRef: DatabaseReference?
    var currentUserRef: DatabaseReference?
    var hasNumberInThisRoom: Bool?
    
    @IBOutlet weak var userCurrentNumber: UILabel!
    @IBOutlet weak var roomCurrentNumber: UILabel!
    
    @IBOutlet weak var takeNumberButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hasNumberInThisRoom = false
        currentUserRef = Database.database().reference().child("Users").child((currentUser?.uid)!)
        
        // Check if the user have number in the this room or different room
        var userCurrentNumber = 0
        currentUserRef?.child("currentNumber").observe(.value, with: { (snapshot) in
            if let value = snapshot.value as? Int {
                if value != 0 {
                    self.takeNumberButton.isEnabled = false
                    
                    // if the user has number, check if the number is in this room
                    self.currentUserRef?.child("currentRoomId").observe(.value, with: { (snapshot) in
                        if let currentRoomId = snapshot.value as? String {
                            if currentRoomId == self.room?.id {
                                self.hasNumberInThisRoom = true
                                
                                self.currentUserRef?.child("currentNumber").observe(.value, with: { (snapshot) in
                                    if let number = snapshot.value as? Int {
                                        userCurrentNumber = number
                                        self.userCurrentNumber.text = userCurrentNumber.description
                                    }
                                })
                            }
                        }
                    })
                }
            }
        })
        

        roomRef = Database.database().reference().child("Rooms")
        // Set up selected room
        if let room = room {
            self.navigationItem.title = room.name
            self.roomCurrentNumber.text = room.currentNumber?.description
            // Change this to get correct currentNumber if user have already pick
            self.userCurrentNumber.text = userCurrentNumber.description
        }
        
        // Reload currentNumber when currentNumber of the selected room changes
        roomRef?.observe(.childChanged, with: { (snapshot) in
            let roomChanged = snapshot.value as? [String: AnyObject]
            let roomChangedId = roomChanged?["id"] as? String
            if self.room?.id == roomChangedId {
                self.room?.currentNumber = roomChanged?["currentNumber"] as? Int
                self.roomCurrentNumber.text = self.room?.currentNumber?.description
                
                if self.hasNumberInThisRoom! && (self.room?.currentNumber!)! > userCurrentNumber {
                    self.currentUserRef?.updateChildValues(["currentNumber" : 0])
                    self.takeNumberButton.isEnabled = true
                }
            }
        })

        // Erase the currentNumber of user if the currentNumber of room is bigger than the currentNumber of user
        
        
    }

    @IBAction func takeNumberButtonClicked(_ sender: UIBarButtonItem) {
        // Update selected room totalNumber when user take number
        self.room?.totalUsers = (self.room?.totalUsers)! + 1
        let currentRoomRef = roomRef?.child((self.room?.id)!)
        currentRoomRef?.updateChildValues(["totalUsers" : self.room?.totalUsers!])
        
        // Update currentNumber of current User when user take number
        currentRoomRef?.observe(.value, with: { (snapshot) in
            let currentRoom = snapshot.value as? [String: AnyObject]
            let numberOfUser = (currentRoom?["totalUsers"] as? Int)!
            self.currentUserRef?.updateChildValues(["currentNumber": numberOfUser,
                                                    "currentRoomId": self.room?.id!])
            self.userCurrentNumber.text = numberOfUser.description
        })
        
//        takeNumberButton.isEnabled = false
    }

}
