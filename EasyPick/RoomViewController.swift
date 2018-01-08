//
//  RoomViewController.swift
//  EasyPick
//
//  Created by Dung Nguyen on 1/8/18.
//  Copyright © 2018 Dung Nguyen - s3598776. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI


class RoomViewController: UIViewController, FUIAuthDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func logoutDidClicked(_ sender: UIButton) {
        handleLogout()
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func handleLogout() {
        let authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        do {
            try authUI?.signOut()
            dismiss(animated: true, completion: nil)
        } catch {
            
        }
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        print("Log in Second VC")
    }

}
