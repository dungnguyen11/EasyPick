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
    var rooms = [Room]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let newRoom = Room(name: "Hospital Room 5", creator: Attendant(name: (currentUser?.displayName)!))
//        let newRoom2 = Room(name: "Hospital Room 6", creator: Attendant(name: (currentUser?.displayName)!))
        
        roomRef = Database.database().reference().child("Rooms")
        
        roomRef.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                self.rooms = []
                for rooms in snapshot.children.allObjects as! [DataSnapshot] {
                    let room = rooms.value as? [String: AnyObject]
                    let roomName = room?["name"]
                    let roomCurrentNumber = room?["currentNumber"]
                    let roomId = room?["id"]
                    
                    let creatorSnapshot = snapshot.childSnapshot(forPath: "creator")
                    let creator = creatorSnapshot.value as? [String: AnyObject]
                    let creatorName = creator?["name"]
                    let creatorId = creator?["id"]
                    
                    
                    
                    let newRoom = Room(id: roomId as! String, name: roomName as! String, creator: nil, currentNumber: roomCurrentNumber as! Int)
                    
                    self.rooms.append(newRoom)
                    print(rooms)
                }
            }
        }
        
        
        
        addRoomToDatabase(roomReference: roomRef, room: newRoom)
        addRoomToDatabase(roomReference: roomRef, room: newRoom2)
        
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
    }
    
    func addRoomToDatabase(roomReference: DatabaseReference, room: Room) {
        roomReference.child(room.id!).setValue(["name" : room.name!,
                                                 "id" : room.id!,
                                                 "currentNumber" : room.currentNumber!])
        roomReference.child(room.id!).child("creator").setValue(["name" : room.creator?.name,
                                                                  "id" : room.creator?.id])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
