//
//  ThoughtCell.swift
//  Random_App
//
//  Created by Saurabh Dixit on 7/3/20.
//  Copyright © 2020 Dixit. All rights reserved.
//

import UIKit
import Firebase
protocol ThoughtDelegate {
    func thoughtOptionsTapped(thought: Thought)
}
class ThoughtCell: UITableViewCell {

    //outlets
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var timestampLbl: UILabel!
    @IBOutlet weak var thoughtTxtLbl: UILabel!
    @IBOutlet weak var likesImg: UIImageView!
    @IBOutlet weak var likesNumLbl: UILabel!
    @IBOutlet weak var commentNumLbl: UILabel!
    @IBOutlet weak var optionsMenu: UIImageView!
    
    //variables
    private var thought: Thought!
    private var delegate: ThoughtDelegate?
        override func awakeFromNib() {
            super.awakeFromNib()
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
            likesImg.addGestureRecognizer(tap)
            likesImg.isUserInteractionEnabled = true
           
        }
        
        @objc func likeTapped() {
            
            Firestore.firestore().collection("thoughts").document(thought.documentId).setData([ NUM_LIKES: thought.numLikes + 1], merge: true)
            //let ref = Firestore.firestore().collection(THOUGHT_REF).document().documentID
          //  let ref = Thought.Firestore.
            
    }
            
        
    func configureCell(thought: Thought, delegate: ThoughtDelegate){
        optionsMenu.isHidden = true
        self.thought = thought
        self.delegate = delegate
        usernameLbl.text = thought.username
        thoughtTxtLbl.text = thought.thoughtTxt
        likesNumLbl.text = String(thought.numLikes)
        commentNumLbl.text = String(thought.numComments)
            let formatter =  DateFormatter()
            formatter.dateFormat = "MMM d hh:mm"
        let timestamp = formatter.string(from: thought.timestamp.dateValue())
       timestampLbl.text = timestamp
        
        if thought.userId == Auth.auth().currentUser?.uid {
            optionsMenu.isHidden = false
            optionsMenu.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(thoughtOptionsTapped))
            optionsMenu.addGestureRecognizer(tap)
        }
   }
    @objc func thoughtOptionsTapped(){
        delegate?.thoughtOptionsTapped(thought: thought)

}

}
