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
    var roomRef: DatabaseReference?
    
    
    @IBOutlet weak var userCurrentNumber: UILabel!
    @IBOutlet weak var roomCurrentNumber: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up selected room
        if let room = room {
            self.navigationItem.title = room.name
            self.roomCurrentNumber.text = room.currentNumber?.description
            self.userCurrentNumber.text = "0"
        }
        
        roomRef = Database.database().reference().child("Rooms")
        // Reload currentNumber when currentNumber of the selected room changes
        roomRef?.observe(.childChanged, with: { (snapshot) in
            let roomChanged = snapshot.value as? [String: AnyObject]
            let roomChangedId = roomChanged?["id"] as? String
            if self.room?.id == roomChangedId {
                self.room?.currentNumber = roomChanged?["currentNumber"] as? Int
                self.roomCurrentNumber.text = self.room?.currentNumber?.description
            }
        })
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
