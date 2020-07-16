//
//  CommentCell.swift
//  Random_App
//
//  Created by Saurabh Dixit on 7/12/20.
//  Copyright © 2020 Dixit. All rights reserved.
//

import UIKit
import Firebase
protocol CommentDelegate {
    func commentOptionsTapped(comment: Comment)
}

class CommentCell: UITableViewCell {
    //outlet
    @IBOutlet weak var usernameTxt: UILabel!
    @IBOutlet weak var timestampTxt: UILabel!
    @IBOutlet weak var commentTxt: UILabel!
    @IBOutlet weak var optionMenu: UIImageView!
    
    //variable
    private var comment: Comment!
    private var delegate: CommentDelegate?
    
    func configureCell(comment: Comment, delegate: CommentDelegate) {
        optionMenu.isHidden = true
        self.comment = comment
        self.delegate = delegate
        usernameTxt.text = comment.username
        commentTxt.text = comment.commentTxt
        let formatter =  DateFormatter()
        formatter.dateFormat = "MMM d hh:mm"
        let timestamp = formatter.string(from: comment.timestamp.dateValue())
        timestampTxt.text = timestamp
        
        if comment.userId == Auth.auth().currentUser?.uid {
            optionMenu.isHidden = false
         optionMenu.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(commentOptionsTapped))
            optionMenu.addGestureRecognizer(tap)
                    }
               }
                @objc func commentOptionsTapped(){
                    delegate?.commentOptionsTapped(comment: comment)

            }

}

