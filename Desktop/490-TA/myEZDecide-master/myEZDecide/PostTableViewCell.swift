//
//  PostTableViewCell.swift
//  myEZDecide
//
//  Created by Jiapei Liang on 2/23/17.
//  Copyright © 2017 liangjiapei. All rights reserved.
//

import UIKit
import Firebase

class PostTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var optionOneButton: UIButton!
    @IBOutlet weak var optionTwoButton: UIButton!
    @IBOutlet weak var optionThreeButton: UIButton!
    @IBOutlet weak var optionFourButton: UIButton!
    
    @IBOutlet weak var optionOneImageView: UIImageView!
    @IBOutlet weak var optionTwoImageView: UIImageView!
    @IBOutlet weak var optionThreeImageView: UIImageView!
    @IBOutlet weak var optionFourImageView: UIImageView!
    
    @IBOutlet weak var commentTextField: UITextField!
    
    var viewController: MainViewController!
    
    var hasVoted = false
    
    var databaseRef: FIRDatabaseReference!
    
    var post: Post! {
        didSet {
            descriptionLabel.text = post.postDescription
            optionOneButton.setTitle(post.optionOneTitle, for: .normal)
            optionTwoButton.setTitle(post.optionTwoTitle, for: .normal)
            optionThreeButton?.setTitle(post.optionThreeTitle, for: .normal)
            optionFourButton?.setTitle(post.optionFourTitle, for: .normal)
            
            if let optionOneImageUrl = post.optionOneImageUrl {
                print("imageUrl: \(optionOneImageUrl)")
                optionOneImageView.image = try! UIImage(data: Data(contentsOf: optionOneImageUrl))
            }
            
            if let optionTwoImageUrl = post.optionTwoImageUrl {
                optionTwoImageView.image = try! UIImage(data: Data(contentsOf: optionTwoImageUrl))
            }
            
            if let optionThreeImageUrl = post.optionThreeImageUrl {
                optionThreeButton.isHidden = false
                optionThreeImageView.isHidden = false
                
                optionThreeImageView?.image = try! UIImage(data: Data(contentsOf: optionThreeImageUrl))
            } else {
                
                optionThreeButton.isHidden = true
                optionThreeImageView.isHidden = true
                
                // optionThreeImageView?.removeFromSuperview()
                // optionThreeButton?.removeFromSuperview()
                // post.optionThreeImageUrl = nil
                
                // self.setNeedsUpdateConstraints()
                // self.layoutIfNeeded()
                
                print("Removed three")
            }
            
            if let optionFourImageUrl = post.optionFourImageUrl {
                optionFourButton.isHidden = false
                optionFourImageView.isHidden = false
                
                optionFourImageView?.image = try! UIImage(data: Data(contentsOf: optionFourImageUrl))
            } else {
                optionFourButton.isHidden = true
                optionFourImageView.isHidden = true
                
                // optionFourImageView?.removeFromSuperview()
                // optionFourButton?.removeFromSuperview()
                post.optionFourImageUrl = nil
                
                self.setNeedsUpdateConstraints()
                self.layoutIfNeeded()
                
                print("Removed Four")
            }
            
            deselectAll()
            
            if let optionId = post.userVoteOptionId {
                
                hasVoted = true
                
                if optionId == post.optionOneId {
                    optionOneButton.backgroundColor = UIColor.green
                } else if optionId == post.optionTwoId {
                    optionTwoButton.backgroundColor = UIColor.green
                } else if optionId == post.optionThreeId {
                    optionThreeButton.backgroundColor = UIColor.green
                } else if optionId == post.optionFourId {
                    optionFourButton.backgroundColor = UIColor.green
                }
            }
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
        databaseRef = FIRDatabase.database().reference()
        
        commentTextField.delegate = self
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    @IBAction func onOptionOneButton(_ sender: Any) {
        
        if hasVoted && optionOneButton.backgroundColor == UIColor.green {
            
            if let userVoteId = post.userVoteId {
                let voteRef = databaseRef.child("posts").child(post.postId!).child("votes").child(userVoteId)
                
                voteRef.updateChildValues([
                    "userId": FIRAuth.auth()?.currentUser?.uid as Any,
                    "optionId": self.post.optionOneId!
                    ])
                alert(alertText: "Successfully updated your vote for option 1")
                
            } else {
                let voteRef = databaseRef.child("posts").child(post.postId!).child("votes").childByAutoId()
                
                voteRef.setValue([
                    "userId": FIRAuth.auth()?.currentUser?.uid,
                    "optionId": self.post.optionOneId
                    ])
                
                alert(alertText: "Successfully voted for option 1")
            }
            
            
        } else if hasVoted {
            deselectAll()
            optionOneButton.backgroundColor = UIColor.green
        } else {
            optionOneButton.backgroundColor = UIColor.green
            hasVoted = true
        }
        
        
        
        
        
    }
    
    @IBAction func onOptionTwoButton(_ sender: Any) {
        
        if hasVoted && optionTwoButton.backgroundColor == UIColor.green {
            
            if let userVoteId = post.userVoteId {
                let voteRef = databaseRef.child("posts").child(post.postId!).child("votes").child(userVoteId)
                
                voteRef.updateChildValues([
                    "userId": FIRAuth.auth()?.currentUser?.uid,
                    "optionId": self.post.optionTwoId
                    ])
                alert(alertText: "Successfully updated your vote for option 2")
                
            } else {
                let voteRef = databaseRef.child("posts").child(post.postId!).child("votes").childByAutoId()
                
                voteRef.setValue([
                    "userId": FIRAuth.auth()?.currentUser?.uid,
                    "optionId": self.post.optionTwoId
                    ])
                
                alert(alertText: "Successfully voted for option 2")
            }
            
            
            
        } else if hasVoted {
            deselectAll()
            optionTwoButton.backgroundColor = UIColor.green
        } else {
            optionTwoButton.backgroundColor = UIColor.green
            hasVoted = true
        }
        
    }
    
    @IBAction func onOptionThreeButton(_ sender: Any) {
        
        if hasVoted && optionThreeButton.backgroundColor == UIColor.green {
            
            if let userVoteId = post.userVoteId {
                let voteRef = databaseRef.child("posts").child(post.postId!).child("votes").child(userVoteId)
                
                voteRef.updateChildValues([
                    "userId": FIRAuth.auth()?.currentUser?.uid,
                    "optionId": self.post.optionThreeId
                    ])
                alert(alertText: "Successfully updated your vote for option 3")
                
            } else {
                let voteRef = databaseRef.child("posts").child(post.postId!).child("votes").childByAutoId()
                
                voteRef.setValue([
                    "userId": FIRAuth.auth()?.currentUser?.uid,
                    "optionId": self.post.optionThreeId
                    ])
                
                alert(alertText: "Successfully voted for option 3")
            }
            
            
            
        } else if hasVoted {
            deselectAll()
            optionThreeButton.backgroundColor = UIColor.green
        } else {
            optionThreeButton.backgroundColor = UIColor.green
            hasVoted = true
        }
        
    }
    
    @IBAction func onOptionFourButton(_ sender: Any) {
        
        if hasVoted && optionFourButton.backgroundColor == UIColor.green {
            
            if let userVoteId = post.userVoteId {
                let voteRef = databaseRef.child("posts").child(post.postId!).child("votes").child(userVoteId)
                
                voteRef.updateChildValues([
                    "userId": FIRAuth.auth()?.currentUser?.uid,
                    "optionId": self.post.optionFourId
                    ])
                alert(alertText: "Successfully updated your vote for option 4")
                
            } else {
                let voteRef = databaseRef.child("posts").child(post.postId!).child("votes").childByAutoId()
                
                voteRef.setValue([
                    "userId": FIRAuth.auth()?.currentUser?.uid,
                    "optionId": self.post.optionFourId
                    ])
                
                alert(alertText: "Successfully voted for option 4")
            }
            
            
            
        } else if hasVoted {
            deselectAll()
            optionFourButton.backgroundColor = UIColor.green
        } else {
            optionFourButton.backgroundColor = UIColor.green
            hasVoted = true
        }
        
    }
    
    private func alert(alertText: String = "") {
        let alertController = UIAlertController(title: nil, message: alertText, preferredStyle: UIAlertControllerStyle.alert)
        
        viewController.present(alertController, animated: true, completion: nil)
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (Timer) in
            
            alertController.dismiss(animated: true, completion: nil)
            
        })
    }
    
    func deselectAll() {
        optionOneButton.backgroundColor = UIColor.clear
        optionTwoButton.backgroundColor = UIColor.clear
        optionThreeButton?.backgroundColor = UIColor.clear
        optionFourButton?.backgroundColor = UIColor.clear
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let commentText = commentTextField.text {
            print("Comment: \(commentTextField.text)")
            
            let postRef = databaseRef.child("posts").child(post.postId!)
            
            let commentRef = postRef.child("comments").childByAutoId()
            
            commentRef.setValue([
                "text": commentText,
                "userId": FIRAuth.auth()?.currentUser?.uid
                ])
            
            commentTextField.text = ""
            
            alert(alertText: "Successfully commented")
        }
        
        return true
    }
    

}
