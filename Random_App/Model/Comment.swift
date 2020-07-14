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
        
        init(username: String, timestamp: Timestamp, commentTxt: String) {
            self.username = username
            self.timestamp = timestamp
            self.commentTxt = commentTxt
            
        }
    
    class func parseData(snapshot: QuerySnapshot?) -> [Comment] {
        var comments = [Comment]()
            
            guard let snap = snapshot else {  //print("hi")
                return comments }
            for document in snap.documents {
                
                let data = document.data()
                let username = data[USERNAME] as? String ?? "Ananymous"
                let timestamp = data[TIMESTAMP] as? Timestamp ?? Timestamp()
                let commentTxt = data[COMMENT_TXT] as? String ?? ""
                
                let newComment = Comment(username: username, timestamp: timestamp, commentTxt: commentTxt)
                comments.append(newComment)
        }
           return comments
   }

}
