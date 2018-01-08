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

class ViewController: UIViewController, FUIAuthDelegate {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        checkLogin()
        
    }
    @IBAction func signInDidClicked(_ sender: UIButton) {
        login()
    }
    

    
    func checkLogin() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "RoomSegue", sender: self)
            }
//            else {
//                self.login()
//            }
        }
    }
    
    func login() {
        let authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        let authViewController = authUI?.authViewController()
        print("in Login")
        self.present(authViewController!, animated: true, completion: nil)
    }
    
//    func logout() {
//        let authUI = FUIAuth.defaultAuthUI()
//        authUI?.delegate = self
//        print("in Logout")
//        do {
//            try authUI?.signOut()
//        } catch {
//
//        }
//    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if user != nil {
            print("Login successfully")
            performSegue(withIdentifier: "RoomSegue", sender: self)
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let roomVC: RoomViewController = segue.destination as! RoomViewController
//
//    }


}

