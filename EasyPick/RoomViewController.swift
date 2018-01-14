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
    
    
    @IBOutlet weak var userCurrentNumber: UILabel!
    @IBOutlet weak var roomCurrentNumber: UILabel!
    
    @IBOutlet weak var takeNumberButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentUserRef = Database.database().reference().child("Users").child((currentUser?.uid)!)
        roomRef = Database.database().reference().child("Rooms")
        
        // Set up selected room
        if let room = room {
            self.navigationItem.title = room.name
            self.roomCurrentNumber.text = room.currentNumber?.description
            // Change this to get correct currentNumber if user have already pick
            self.userCurrentNumber.text = "0"
        }
        
        // Reload currentNumber when currentNumber of the selected room changes
        roomRef?.observe(.childChanged, with: { (snapshot) in
            let roomChanged = snapshot.value as? [String: AnyObject]
            let roomChangedId = roomChanged?["id"] as? String
            if self.room?.id == roomChangedId {
                self.room?.currentNumber = roomChanged?["currentNumber"] as? Int
                self.roomCurrentNumber.text = self.room?.currentNumber?.description
            }
        })
        
        // Check if the user have the number in the room
        
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
            self.currentUserRef?.updateChildValues(["currentNumber": numberOfUser])
            self.userCurrentNumber.text = numberOfUser.description
        })
        
//        takeNumberButton.isEnabled = false
    }

}
