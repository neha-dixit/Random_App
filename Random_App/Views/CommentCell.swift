//
//  CommentCell.swift
//  Random_App
//
//  Created by Saurabh Dixit on 7/12/20.
//  Copyright © 2020 Dixit. All rights reserved.
//

import UIKit
import Firebase
class CommentCell: UITableViewCell {
    //outlet
    @IBOutlet weak var usernameTxt: UILabel!
    @IBOutlet weak var timestampTxt: UILabel!
    @IBOutlet weak var commentTxt: UILabel!
    
    func configureCell(comment: Comment){
        usernameTxt.text = comment.username
        let formatter =  DateFormatter()
        formatter.dateFormat = "MMM d hh:mm"
        let timestamp = formatter.string(from: comment.timestamp.dateValue())
        timestampTxt.text = timestamp
        commentTxt.text = comment.commentTxt
    }
}

