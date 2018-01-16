//
//  RoomTableViewController.swift
//  EasyPick
//
//  Created by Dung Nguyen on 1/13/18.
//  Copyright © 2018 Dung Nguyen - s3598776. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI

class RoomTableViewController: UITableViewController, FUIAuthDelegate {
    
    //Firebase
    var currentUser = Auth.auth().currentUser
    var roomRef: DatabaseReference!
    var userRef: DatabaseReference!
    var rooms = [Room]()
    
    @IBOutlet var roomTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let newRoom = Room(name: "Hospital Room 5", creator: Attendant(name: (currentUser?.displayName)!))
//        let newRoom2 = Room(name: "Hospital Room 6", creator: Attendant(name: (currentUser?.displayName)!))
        
        // Add user if he/she does not have information on realtime-database
        var isUserSaved = false
        userRef = Database.database().reference().child("Users")
        userRef.observeSingleEvent(of: .value) { (snapshot) in
            print("In check user")
            for users in snapshot.children.allObjects as! [DataSnapshot] {
                let user = users.value as? [String: AnyObject]
                let userId = user?["id"]
                if self.currentUser?.uid == userId?.description {
                    isUserSaved = true
                }
            }
            print("isUserSaved: \(isUserSaved)")
            if !isUserSaved {
                let newUser = RoomUser(id: (self.currentUser?.uid)!,
                                       name: (self.currentUser?.displayName)!)
                self.addUserToDatabase(userReference: self.userRef, user: newUser)
            }
        }
        
        
        // Load all available rooms from Firebase database
        roomRef = Database.database().reference().child("Rooms")
        roomRef.observe( .value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                self.rooms = []
                for rooms in snapshot.children.allObjects as! [DataSnapshot] {
                    let room = rooms.value as? [String: AnyObject]
                    let roomName = room?["name"]
                    let roomCurrentNumber = room?["currentNumber"]
                    let roomTotalUsers = room?["totalUsers"] ?? 0 as AnyObject
                    let roomId = room?["id"]
                    let roomCreateId = room?["creatorId"]
                    
                    let newRoom = Room(id: roomId as! String,
                                       name: roomName as! String,
                                       creatorId: roomCreateId as! String,
                                       currentNumber: roomCurrentNumber as! Int,
                                       totalUsers: roomTotalUsers as? Int)
                    self.rooms.append(newRoom)
                    
                    print("on loop, rooms count: \(self.rooms.count)")
                }
                self.roomTableView.reloadData()
            }
        }
        
        // Reload tableView when currentNumber or name of a room change
        roomRef.observe(.childChanged) { (snapshot) in
            print("snapshot in change: \(snapshot)")
            let roomChanged = snapshot.value as? [String: AnyObject]
            let roomChangedId = roomChanged?["id"] as? String
            for room in self.rooms {
                if room.id == roomChangedId {
                    room.currentNumber = roomChanged?["currentNumber"] as? Int
                    room.name = roomChanged?["name"] as? String
                }
            }
            self.roomTableView.reloadData()
            print("in reload when change")
        }
        
        // Reload tableView when a room is deleted
        roomRef.observe(.childRemoved) { (snapshot) in
            print("snapshot in remove: \(snapshot)")
            let roomDeleted = snapshot.value as? [String: AnyObject]
            let roomDeletedId = roomDeleted?["id"] as? String
            for (index, room) in self.rooms.enumerated() {
                if room.id == roomDeletedId {
                    self.rooms.remove(at: index)
                }
            }
            self.roomTableView.reloadData()
        }
        print("onViewDidLoad, rooms count: \(rooms.count)")
    }
    
    
    // MARK: Private functions
    // Add room to Database
    func addRoomToDatabase(roomReference: DatabaseReference, room: Room) {
        roomReference.child(room.id!).setValue(["name" : room.name!,
                                                 "id" : room.id!,
                                                 "currentNumber" : room.currentNumber!,
                                                 "creatorId": nil])
    }

    // Add user to Database
    func addUserToDatabase(userReference: DatabaseReference, user: RoomUser) {
        // Need to add currentRoom to user info on database
        userRef.child(user.id!).setValue(["name" : user.name!,
                                          "id": user.id!,
                                          "currentNumber": user.currentNumber!])
    }
    
    
    // MARK: Navigation
    @IBAction func LogoutDidClicked(_ sender: UIBarButtonItem) {
        handleLogout()
        print("lout out did clicked")
        dismiss(animated: true, completion: nil)
    }
  
    @objc func handleLogout() {
        let authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        do {
            try authUI?.signOut()
            print("try log out")
            dismiss(animated: true, completion: nil)
        } catch {
            print("log out unsuccessfully")
        }
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        print("Log in Second VC")
    }
    
    // prepare a selected room for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier ?? "") {
        case "ShowDetail":
            guard let roomDetailViewController = segue.destination as? RoomViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedRoomCell = sender as? RoomTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedRoomCell) else {
                fatalError("The selected room is not display by the table")
            }
            
            let selectedRoom = self.rooms[indexPath.row]
            roomDetailViewController.room = selectedRoom
            
        default:
            fatalError("Unexpected identifier: \(String(describing: segue.identifier))")
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
         print("on Table View Load, rooms count: \(rooms.count)")
        return rooms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "RoomTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RoomTableViewCell else {
            fatalError("The dequeued cell is not an instance of RoomTableViewCell")
        }

       let room = rooms[indexPath.row]
        
        cell.roomNameLabel.text = room.name
        cell.currentNumberLabel.text = "Current number: \(room.currentNumber!.description)"
        

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
