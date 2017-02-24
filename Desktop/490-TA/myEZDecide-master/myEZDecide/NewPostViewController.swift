//
//  NewPostViewController.swift
//  myEZDecide
//
//  Created by Jiapei Liang on 2/22/17.
//  Copyright © 2017 liangjiapei. All rights reserved.
//

import UIKit
import DKImagePickerController
import Firebase
import FirebaseDatabase
import FirebaseStorage
import MBProgressHUD

class NewPostViewController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    
    @IBOutlet weak var optionOneTextField: UITextField!
    @IBOutlet weak var optionTwoTextField: UITextField!
    @IBOutlet weak var optionThreeTextField: UITextField!
    @IBOutlet weak var optionFourTextField: UITextField!
    
    @IBOutlet weak var optionOneImageView: UIImageView!
    @IBOutlet weak var optionTwoImageView: UIImageView!
    @IBOutlet weak var optionThreeImageView: UIImageView!
    @IBOutlet weak var optionFourImageView: UIImageView!
    
    var optionsCount = 0
    
    var hasSelectImage1 = false
    var hasSelectImage2 = false
    
    let pickerController = DKImagePickerController()
    
    var databaseRef: FIRDatabaseReference!
    var storageRef: FIRStorageReference!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "Post Your Question"
        
        descriptionTextView.delegate = self
        
        // Make sure the cursor starts from the top of text view
        self.automaticallyAdjustsScrollViewInsets = false
        
        // Initialize pickerController
        pickerController.singleSelect = true
        pickerController.showsCancelButton = true
        
        databaseRef = FIRDatabase.database().reference()
        storageRef = FIRStorage.storage().reference()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.characters.count == 0 {
            placeholderLabel.isHidden = false
        } else {
            placeholderLabel.isHidden = true
        }
    }
    
    
    @IBAction func onOptionOneImageView(_ sender: UITapGestureRecognizer) {
        
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            print("didSelectAssets")
            print(assets)
            
            if assets.count == 1 {
                assets[0].fetchOriginalImage(true, completeBlock: { (image, info) in
                    
                    self.optionOneImageView.image = image
                    
                    self.optionsCount += 1
                    
                    self.hasSelectImage1 = true
                })
                
                self.pickerController.deselectAllAssets()
            }
        }
        
        self.present(pickerController, animated: true)
    }
    
    @IBAction func onOptionTwoImageView(_ sender: UITapGestureRecognizer) {
        
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            print("didSelectAssets")
            print(assets)
            
            if assets.count == 1 {
                assets[0].fetchOriginalImage(true, completeBlock: { (image, info) in
                    
                    self.optionTwoImageView.image = image
                    
                    self.optionsCount += 1
                    
                    self.hasSelectImage2 = true
                    
                })
                
                self.pickerController.deselectAllAssets()
            }
        }
        
        self.present(pickerController, animated: true)
        
    }
    
    
    @IBAction func onOptionThreeImageVIew(_ sender: UITapGestureRecognizer) {
        
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            print("didSelectAssets")
            print(assets)
            
            if assets.count == 1 {
                assets[0].fetchOriginalImage(true, completeBlock: { (image, info) in
                    
                    self.optionThreeImageView.image = image
                    
                    self.optionsCount += 1
                    
                })
                
                self.pickerController.deselectAllAssets()
            }
        }
        
        self.present(pickerController, animated: true)
        
    }
    

    @IBAction func onOptionFourImageView(_ sender: UITapGestureRecognizer) {
        
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            print("didSelectAssets")
            print(assets)
            
            if assets.count == 1 {
                assets[0].fetchOriginalImage(true, completeBlock: { (image, info) in
                    
                    self.optionFourImageView.image = image
                    
                    self.optionsCount += 1
                    
                })
                
                self.pickerController.deselectAllAssets()
            }
        }
        
        self.present(pickerController, animated: true)
        
    }
    
    
    @IBAction func onSubmitButton(_ sender: Any) {
        
        if validateInputs() {
        
            // Display HUD right before the request is made
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            let postRefChild = self.databaseRef.child("posts").childByAutoId()
            postRefChild.setValue([
                "description": descriptionTextView.text!,
                "options": []
                ])
            
            let optionOneRefChild = postRefChild.child("options").childByAutoId()
            optionOneRefChild.setValue([
                "image": "",
                "title": optionOneTextField.text!
                ])
            
            let imagesStorageRef = storageRef.child("images")
            
            var data = Data()
            
            data = UIImageJPEGRepresentation(optionOneImageView.image!, 0.1)!
            
            // set upload path
            var filePath = "\(postRefChild.key)/\(optionOneRefChild.key)_option1/"
            var metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpg"
            
            imagesStorageRef.child(filePath).put(data, metadata: metaData) {
                (metaData, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                if let metaData = metaData {
                    let downloadURL = metaData.downloadURL()!.absoluteString
                    
                    // store downloadURL into database
                    optionOneRefChild.updateChildValues(["image": downloadURL])
                }
            }
            
            
            
            let optionTwoRefChild = postRefChild.child("options").childByAutoId()
            optionTwoRefChild.setValue([
                "image": "",
                "title": optionTwoTextField.text!
                ])
            
            data = Data()
            data = UIImageJPEGRepresentation(optionTwoImageView.image!, 0.1)!
            
            // set upload path
            filePath = "\(postRefChild.key)/\(optionTwoRefChild.key)_option2/"
            metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpg"
            
            imagesStorageRef.child(filePath).put(data, metadata: metaData) {
                (metaData, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                if let metaData = metaData {
                    let downloadURL = metaData.downloadURL()!.absoluteString
                    
                    // store downloadURL into database
                    optionTwoRefChild.updateChildValues(["image": downloadURL])
                }
            }
            
            if optionsCount >= 3 {
                let optionThreeRefChild = postRefChild.child("options").childByAutoId()
                optionThreeRefChild.setValue([
                    "image": "",
                    "title": optionThreeTextField.text!
                    ])
                
                data = Data()
                data = UIImageJPEGRepresentation(optionThreeImageView.image!, 0.1)!
                
                // set upload path
                filePath = "\(postRefChild.key)/\(optionThreeRefChild.key)_option3/"
                metaData = FIRStorageMetadata()
                metaData.contentType = "image/jpg"
                
                imagesStorageRef.child(filePath).put(data, metadata: metaData) {
                    (metaData, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    
                    if let metaData = metaData {
                        let downloadURL = metaData.downloadURL()!.absoluteString
                        
                        // store downloadURL into database
                        optionThreeRefChild.updateChildValues(["image": downloadURL])
                    }
                }
                
            }
            
            if optionsCount == 4 {
                let optionFourRefChild = postRefChild.child("options").childByAutoId()
                optionFourRefChild.setValue([
                    "image": "",
                    "title": optionFourTextField.text!
                    ])
                
                data = Data()
                data = UIImageJPEGRepresentation(optionFourImageView.image!, 0.1)!
                
                // set upload path
                filePath = "\(postRefChild.key)/\(optionFourRefChild.key)_option4/"
                metaData = FIRStorageMetadata()
                metaData.contentType = "image/jpg"
                
                imagesStorageRef.child(filePath).put(data, metadata: metaData) {
                    (metaData, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    
                    if let metaData = metaData {
                        let downloadURL = metaData.downloadURL()!.absoluteString
                        
                        // store downloadURL into database
                        optionFourRefChild.updateChildValues(["image": downloadURL])
                    }
                }
            }
            
            // Hide HUD once the network request comes back (must be done on main UI thread)
            MBProgressHUD.hide(for: self.view, animated: true)
            
            alertAndExit(alertText: "Successfully made a post")
            
        }
        
    }
    
    private func validateInputs() -> Bool {
        
        var result = true
        
        if let description = descriptionTextView.text {
            if description.isEmpty {
                alert(alertText: "Please enter a description")
                result = false
            }
        }
        
        if let option1 = optionOneTextField.text {
            if option1.isEmpty {
                alert(alertText: "Please enter a title for option 1")
                result = false
            }
        }
        
        if !hasSelectImage1 {
            alert(alertText: "Please select an image for option 1")
            result = false
        }
        
        if let option2 = optionTwoTextField.text {
            if option2.isEmpty {
                alert(alertText: "Please enter a title for option 2")
                result = false
            }
        }
        
        if !hasSelectImage2 {
            alert(alertText: "Please select an image for option 2")
            result = false
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
                let viewController = self.navigationController?.topViewController as! MainViewController
                viewController.doSearch()
            })
            
        })
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        
        view.endEditing(true)
        
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
