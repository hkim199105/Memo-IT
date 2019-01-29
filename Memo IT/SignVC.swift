//
//  SignVC.swift
//  MyMemory
//
//  Created by Kim Hakyoung on 26/01/2019.
//  Copyright © 2019 hkim. All rights reserved.
//

import UIKit
import GoogleSignIn

class SignVC: UIViewController, GIDSignInUIDelegate {
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signInSilently()
        GIDGoogleUser *user = [GIDSignIn sharedInstance].currentUser;
        
    }
    
    @IBAction func didTapSignOut(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
    }
}
