//
//  ViewController.swift
//  RewardMe
//
//  Created by Cosmin on 27/02/2019.
//  Copyright © 2019 Cosmin. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    @IBOutlet weak var userLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Auth.auth().addStateDidChangeListener { (_, user) in
            if user != nil {
                self.userLabel.text = "Logged as " + (user?.displayName)!
            } else {
                print ("User is not logged in")
                self.performSegue(withIdentifier: "goToLogin", sender: self)
            }
        }
    }
    
    @IBAction func onLogoutPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            userLabel.text = "Not logged in"
        }
        catch {
            print (error)
        }
    }
}

