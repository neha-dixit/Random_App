//
//  Comment.swift
//  Random_App
//
//  Created by Saurabh Dixit on 7/12/20.
//  Copyright © 2020 Dixit. All rights reserved.
//

import Foundation
import Firebase
class Comment {
    //private variable
        
        private(set) var username: String!
        private(set) var timestamp: Timestamp!
        private(set) var commentTxt: String!
        
        
        init(username: String, timstamp: Timestamp, commentTxt: String) {
            
            self.username = username
            self.timestamp = timstamp
            self.commentTxt = commentTxt
           
        }
        
//        class func parseData(snapshot: QuerySnapshot?) -> [Thought]{
//            var thoughts =  [Thought]()
//            guard let snap = snapshot else { return thoughts }
//            for document in (snap.documents){
//                //print(document.data())
//                let data = document.data()
//                let username = data[USERNAME] as! String
//                //let timestamp = data[TIMESTAMP] as? Date ?? Date()
//                let timestamp = data[TIMESTAMP] as? Timestamp ?? Timestamp()
//                let thoughtTxt = data[THOUGHT_TXT] as? String ?? ""
//                let num_likes = data[NUM_LIKES] as? Int ?? 0
//                let num_Comment = data[NUM_COMMENT] as? Int ?? 0
//                let documentId = document.documentID
//
//                let newThoughts = Thought(username: username, timstamp: timestamp, thoughtTxt: thoughtTxt, numLikes: num_likes, numComments: num_Comment, documentId: documentId)
//                thoughts.append(newThoughts)
//        }
//            return thoughts
//    }

}
