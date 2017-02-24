//
//  SignUpViewController.swift
//  myEZDecide
//
//  Created by Jiapei Liang on 2/22/17.
//  Copyright © 2017 liangjiapei. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD

class SignUpViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        navigationItem.title = "Sign Up"
        
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onSignUpButton(_ sender: Any) {
        
        if validateInputs() {
            
            // Display HUD right before the request is made
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                
                // Hide HUD once the network request comes back (must be done on main UI thread)
                MBProgressHUD.hide(for: self.view, animated: true)
                
                if let error = error {
                    print(error.localizedDescription)
                }
                
                if user != nil {
                    print("Successfully signed up")
                    
                    user?.sendEmailVerification(completion: { (error) in
                        
                        self.alertAndExit(alertText: "Verification email sent")
                        
                    })

                }
            })
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
            } else if let confirmPassword = confirmPasswordTextField.text {
                if confirmPassword.isEmpty {
                    alert(alertText: "Please confirm your password")
                    result = false
                } else if password != confirmPassword {
                    alert(alertText: "Please match your passwords")
                    result = false
                }
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
    
    private func alertAndExit(alertText: String = "") {
        let alertController = UIAlertController(title: nil, message: alertText, preferredStyle: UIAlertControllerStyle.alert)
        
        present(alertController, animated: true, completion: nil)
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (Timer) in
            
            alertController.dismiss(animated: true, completion: { 
                self.navigationController?.popViewController(animated: true)
            })
            
        })
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
