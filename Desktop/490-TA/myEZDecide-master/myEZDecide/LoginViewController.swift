//
//  ViewController.swift
//  myEZDecide
//
//  Created by Jiapei Liang on 2/22/17.
//  Copyright © 2017 liangjiapei. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import MBProgressHUD
import GoogleSignIn
class LoginViewController: UIViewController , GIDSignInUIDelegate{

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func onGoogleSignIn(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }

    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginWithEmailButton(_ sender: Any) {
        
        if validateInputs() {
            // Display HUD right before the request is made
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                
                // Hide HUD once the network request comes back (must be done on main UI thread)
                MBProgressHUD.hide(for: self.view, animated: true)
                
                if let error = error {
                    self.alert(alertText: "Failed to login")
                    print(error.localizedDescription)
                }
                
                if let user = user {
                    print("Successfully logged in")
                    
                    if !user.isEmailVerified {
                        self.alert(alertText: "Please verify your email before login")
                    }
                    
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
                
            }
        }
        
    }
    
    @IBAction func onLoginWithFacebookButton(_ sender: Any) {
        
        let loginManager: FBSDKLoginManager = FBSDKLoginManager.init()
        
        loginManager.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self) { (result: FBSDKLoginManagerLoginResult?, error: Error?) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                if let result = result {
                    if (result.isCancelled) {
                        print("Login with Facebook was cancelled 2")
                    } else {
                        print("Successfully logged in with Facebook 2")
                        self.performSegue(withIdentifier: "loginSegue", sender: nil)
                    }
                } else {
                    print("Failed to login with facebook 2")
                    return
                }
            }
        }
    }
    
    private func validateInputs() -> Bool {
        
        var result = true
        
        if let email = emailTextField.text {
            if email.isEmpty {
                alert(alertText: "Please enter an email")
                result = false
            } else if !email.contains("@") {
                alert(alertText: "Please enter a valid email")
                result = false
            }
        }
        
        if let password = passwordTextField.text {
            if password.isEmpty {
                alert(alertText: "Please enter a password")
                result = false
            }
        }
        
        return result
    }
    
    private func alert(alertText: String = "") {
        let alertController = UIAlertController(title: nil, message: alertText, preferredStyle: UIAlertControllerStyle.alert)
        
        present(alertController, animated: true, completion: nil)
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (Timer) in
            
            alertController.dismiss(animated: true, completion: nil)
            
        })
    }

}

