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
    
    func checkLogin() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
//                self.logout()
            } else {
                self.login()
            }
        }
    }
    
    func login() {
        let authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        let authViewController = authUI?.authViewController()
        self.present(authViewController!, animated: true, completion: nil)
    }
    
    func logout() {
        let authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        
        do {
            try authUI?.signOut()
        } catch {
            
        }
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if user != nil {
            print("Login successfully")
        }
    }


}

