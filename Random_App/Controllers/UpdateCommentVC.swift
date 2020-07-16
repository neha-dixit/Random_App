//
//  UpdateCommentVC.swift
//  Random_App
//
//  Created by Saurabh Dixit on 7/15/20.
//  Copyright © 2020 Dixit. All rights reserved.
//

import UIKit
import Firebase
class UpdateCommentVC: UIViewController {
    //outlets
    @IBOutlet weak var commentTxt: UITextView!
    @IBOutlet weak var updateBtn: UIButton!
   //variable
    var commentData: (comment: Comment, thought: Thought)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        commentTxt.layer.cornerRadius = 10
        updateBtn.layer.cornerRadius = 10
        
        
    }

    @IBAction func updateBtnTapped(_ sender: Any) {
        //update comment
    Firestore.firestore().collection(THOUGHT_REF).document(commentData.thought.documentId).collection(COMMENT_REF).document(commentData.comment.documentId).updateData([COMMENT_TXT : commentTxt.text]) { (error) in
            if let error = error {
                debugPrint("Error while updating comment", error.localizedDescription)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
}
}
