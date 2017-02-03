//
//  ViewController.swift
//  Tweeter
//
//  Created by zheng wu on 2/11/16.
//  Copyright © 2016 zheng wu. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    


    @IBAction func onLogin(_ sender: Any) {
        User.loginWithCompletion() {
            (user: User?, error: NSError?) in
            if user != nil {
                self.performSegue(withIdentifier: "loginSegue", sender: self)
                print("Perform segue")
            } else {
                print(error!)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

