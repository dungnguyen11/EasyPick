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
    var user: RoomUser?
    var currentUser = Auth.auth().currentUser
    var currentRoomRef: DatabaseReference?
    var currentUserRef: DatabaseReference?
    var hasNumberInThisRoom: Bool?
    
    @IBOutlet weak var userCurrentNumber: UILabel!
    @IBOutlet weak var roomCurrentNumber: UILabel!
    
    @IBOutlet weak var takeNumberButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        takeNumberButton.isEnabled = true
        hasNumberInThisRoom = false
        
        //Handle change in current user change
        currentUserRef = Database.database().reference().child("Users").child((currentUser?.uid)!)
        currentUserRef?.observe(.value, with: { (snapshot) in
            let userObject = snapshot.value as? [String: AnyObject]
            let userId = self.currentUser?.uid
            let userName = self.currentUser?.displayName
            let currentNumberOfUser = userObject!["currentNumber"] as! Int
            let currentRoomIdOfUser = userObject!["currentRoomId"] as! String
            self.user = RoomUser(id: userId!,
                                 name: userName!,
                                 currentNumber: currentNumberOfUser,
                                 currentRoomId: currentRoomIdOfUser)
//            print("user: \(self.user?.currentNumber)")
            
            // Check if the user have number in this room or different room, if have, display the number to UI
            if (self.user?.currentNumber != 0) {
                if self.user?.currentRoomId == self.room?.id {
                    self.hasNumberInThisRoom = true
                    self.userCurrentNumber.text = self.user?.currentNumber?.description
                } else {
                    self.userCurrentNumber.text = "0"
                }
                self.takeNumberButton.isEnabled = false
            }
        })
        
        // Handle change in current room
        currentRoomRef = Database.database().reference().child("Rooms").child((self.room?.id)!)
        currentRoomRef?.observe(.value, with: { (snapshot) in
            let roomObject = snapshot.value as? [String : AnyObject]
            self.room?.id = roomObject!["id"] as? String
            self.room?.name = roomObject!["name"] as? String
            self.room?.currentNumber = roomObject!["currentNumber"] as? Int
            self.room?.creatorId = roomObject!["creatorId"] as? String
            self.room?.totalUsers = roomObject!["totalUsers"] as? Int
            
            // Set up UI
            if let room = self.room {
                self.navigationItem.title = room.name
                self.roomCurrentNumber.text = room.currentNumber?.description
            }
            
            // Reset currentNumber of user to 0, when currentNumber of room larger than currentNumber of user
            if self.hasNumberInThisRoom! && (self.room!.currentNumber! > self.user!.currentNumber!) {
                self.currentUserRef?.updateChildValues(["currentNumber" : 0])
                self.takeNumberButton.isEnabled = true
            }
        })
    }

    // CHECK THIS
    @IBAction func takeNumberButtonClicked(_ sender: UIBarButtonItem) {
        // Update selected room totalNumber when user take number
        self.currentRoomRef?.updateChildValues(["totalUsers" : (self.room?.totalUsers!)! + 1])
        
        // Update currentNumber of current User when user take number
        currentRoomRef?.observe(.value, with: { (snapshot) in
            let currentRoom = snapshot.value as? [String: AnyObject]
            let numberOfUser = (currentRoom?["totalUsers"] as? Int)!
            self.currentUserRef?.updateChildValues(["currentNumber": numberOfUser,
                                                    "currentRoomId": self.room?.id!])
        })
    }

}
