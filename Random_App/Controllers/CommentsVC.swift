//
//  CommentsVC.swift
//  Random_App
//
//  Created by Saurabh Dixit on 7/12/20.
//  Copyright © 2020 Dixit. All rights reserved.
//

import UIKit
import Firebase
class CommentsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CommentDelegate {
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
    
    func commentOptionsTapped(comment: Comment) {
        // here we add alerts for edit and delete and cancel as well
        let alert = UIAlertController(title: "Edit Comment", message: "You can delete or edit", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { (action) in
            // delete the comment
            //           //this is how we delete a thing so we need to do this way when we only need to delte something no need to update it in somewhere self.firestore.collection(THOUGHT_REF).document(self.thought.documentId).collection(COMMENT_REF).document(comment.documentId).delete { (error) in
            //                if let error = error {
            //                    debugPrint("Error while deleting", error.localizedDescription)
            //                } else {
            //                    alert.dismiss(animated: true, completion: nil)
            //                }
            //            }
            
            //second method here we have to run the transcation same as we did in comment add
            guard let commentTxt = self.addCommentTxt.text else { return }
            self.firestore.runTransaction({ (transaction, errorPointer) -> Any? in
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
                transaction.updateData([NUM_COMMENT : oldNumComments - 1], forDocument: self.thoughtRef)
                // generate new comment
                let commentRef = self.firestore.collection(THOUGHT_REF).document(self.thought.documentId).collection(COMMENT_REF).document(comment.documentId)
                transaction.deleteDocument(commentRef)
                return nil
                
            }) { (object, error) in
                if let error = error {
                    debugPrint("Transaction failed\(error.localizedDescription)")
                } else {
                    
                    alert.dismiss(animated: true, completion: nil)
                }
                
            }
        }
        let editAction = UIAlertAction(title: "Edit", style: .default) { (action) in
            // EDIT COMMENT
            self.performSegue(withIdentifier: "toEditComment", sender: (comment, self.thought))
            alert.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            //cancel comment
        }
        alert.addAction(editAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? UpdateCommentVC {
            if let commentData = sender as? (comment: Comment, thought: Thought){
                destination.commentData = commentData
            }
        }
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
                USERNAME: self.username!,
                USER_ID: Auth.auth().currentUser?.uid ?? ""
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
            cell.configureCell(comment: comments[indexPath.row], delegate: self)
            return cell
        }
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

