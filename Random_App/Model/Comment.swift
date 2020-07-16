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
        private(set) var documentId: String!
        private (set) var userId: String!
    
        
    init(username: String, timestamp: Timestamp, commentTxt: String, documentId: String, userId: String) {
            self.username = username
            self.timestamp = timestamp
            self.commentTxt = commentTxt
            self.documentId = documentId
            self.userId = userId
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
                let documentId = document.documentID
                let userId = data[USER_ID] as? String ?? ""
                
                let newComment = Comment(username: username, timestamp: timestamp, commentTxt: commentTxt, documentId: documentId, userId: userId)
                comments.append(newComment)
        }
           return comments
   }

}
