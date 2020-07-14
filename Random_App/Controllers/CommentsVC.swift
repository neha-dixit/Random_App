//
//  CommentsVC.swift
//  Random_App
//
//  Created by Saurabh Dixit on 7/12/20.
//  Copyright © 2020 Dixit. All rights reserved.
//

import UIKit
import Firebase
class CommentsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    // outlets
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var addCommentTxt: UITextField!
    @IBOutlet weak var keyboardView: UIView!
    //variable
    var thought: Thought!
    var comments = [Comment]()
    var thoughtRef: DocumentReference!
    let firestore = Firestore.firestore()
    var username: String!
    var commentListner: ListenerRegistration!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableview.estimatedRowHeight = 40
        tableview.rowHeight = UITableView.automaticDimension
        tableview.delegate = self
        tableview.dataSource = self
        self.view.bindToKeyboard()
        // Do any additional setup after loading the view.
        thoughtRef = firestore.collection(THOUGHT_REF).document(thought.documentId)
        if let name = Auth.auth().currentUser?.displayName {
            username = name
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        commentListner = firestore.collection(THOUGHT_REF).document(self.thought.documentId).collection(COMMENT_REF)
        .order(by: TIMESTAMP, descending: true)
            .addSnapshotListener({ (snapshot, error) in
            guard let snapshot = snapshot else {
                debugPrint("Error in fetching comments \(error!)")
                return
            }
            
            self.comments.removeAll()
            self.comments = Comment.parseData(snapshot: snapshot)
            self.tableview.reloadData()
        })
    }
    override func viewDidDisappear(_ animated: Bool) {
        commentListner.remove()
    }

    
    @IBAction func addCommentBtnTapped(_ sender: Any) {
        guard let commentTxt = addCommentTxt.text else { print("addbutton else")
            return }
        //self.addCommentTxt.text = ""
        firestore.runTransaction({ (transaction, errorPointer) -> Any? in
            let thoughtDocument: DocumentSnapshot
            // read
            do{
                try thoughtDocument = transaction.getDocument(Firestore.firestore().collection(THOUGHT_REF).document(self.thought.documentId))
                
            }
            catch let error as NSError {
                debugPrint("Fetch Error \(error.localizedDescription)")
                return nil
            }
            //print("thoughtDocument", thoughtDocument)
            //get what we read
            guard let oldNumComments = thoughtDocument.data()![NUM_COMMENT] as? Int else { return nil}
            //print("old comment", oldNumComments)
            //update
            transaction.updateData([NUM_COMMENT : oldNumComments + 1], forDocument: self.thoughtRef)
            // generate new comment
            let newCommentRef = self.firestore.collection(THOUGHT_REF).document(self.thought.documentId).collection(COMMENT_REF).document()
            
            transaction.setData([
                COMMENT_TXT : commentTxt,
                TIMESTAMP: FieldValue.serverTimestamp(),
                USERNAME: self.username!
            ], forDocument: newCommentRef)
           
            return nil
            
        }) { (object, error) in
            if let error = error {
                debugPrint("error\(error.localizedDescription)")
            } else {
                self.addCommentTxt.text = ""
                self.addCommentTxt.resignFirstResponder()
            }
        
    }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell =  tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? CommentCell {
            cell.configureCell(comment: comments[indexPath.row])
           
            return cell
        }
            return UITableViewCell()
    }
    
 func numberOfSections(in tableView: UITableView) -> Int {
    return 1
   }
}

