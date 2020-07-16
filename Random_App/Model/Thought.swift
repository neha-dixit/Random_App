//
//  Thought.swift
//  Random_App
//
//  Created by Saurabh Dixit on 7/3/20.
//  Copyright © 2020 Dixit. All rights reserved.
//

import Foundation
import Firebase

class Thought {
    //private variable
    
    private(set) var username: String!
    private(set) var timestamp: Timestamp!
    private(set) var thoughtTxt: String!
    private(set) var numLikes: Int!
    private(set) var numComments: Int!
    private(set) var documentId: String!
    private (set) var userId: String!
    
    init(username: String, timstamp: Timestamp, thoughtTxt: String, numLikes: Int, numComments: Int, documentId: String, userId: String) {
        
        self.username = username
        self.timestamp = timstamp
        self.thoughtTxt = thoughtTxt
        self.numLikes = numLikes
        self.numComments = numComments
        self.documentId = documentId
        self.userId = userId
    }
    
    class func parseData(snapshot: QuerySnapshot?) -> [Thought]{
        var thoughts =  [Thought]()
        print("give some thoughts",thoughts)
        guard let snap = snapshot else { return thoughts }
        for document in (snap.documents){
            //print(document.data())
            let data = document.data()
            let username = data[USERNAME] as! String
            //let timestamp = data[TIMESTAMP] as? Date ?? Date()
            let timestamp = data[TIMESTAMP] as? Timestamp ?? Timestamp()
            let thoughtTxt = data[THOUGHT_TXT] as? String ?? ""
            let num_likes = data[NUM_LIKES] as? Int ?? 0
            let num_Comment = data[NUM_COMMENT] as? Int ?? 0
            let documentId = document.documentID
            let userId = data[USER_ID] as? String ?? ""
            
            let newThoughts = Thought(username: username, timstamp: timestamp, thoughtTxt: thoughtTxt, numLikes: num_likes, numComments: num_Comment, documentId: documentId, userId: userId)
            thoughts.append(newThoughts)
    }
        return thoughts
}

}
