//
//  ViewController.swift
//  EasyPick
//
//  Created by Dung Nguyen on 1/8/18.
//  Copyright © 2018 Dung Nguyen - s3598776. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI

class LoginViewController: UIViewController, FUIAuthDelegate, UINavigationControllerDelegate {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLogin()
    }
    

    @IBAction func LoginButtonClicked(_ sender: UIBarButtonItem) {
        print("Log in did clicked")
        login()
    }
    
    
    func checkLogin() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "RoomSegue", sender: self)
            }
        }
    }
    
    func login() {
        let authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        let authViewController = authUI?.authViewController()
        print("in Login")
        self.present(authViewController!, animated: true, completion: nil)
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if user != nil {
            print("Login successfully")
            performSegue(withIdentifier: "RoomSegue", sender: self)
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let roomVC: RoomTableViewController = segue.destination as! RoomTableViewController
//
//
//    }


}

