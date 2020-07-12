//
//  ViewController.swift
//  Random_App
//
//  Created by Saurabh Dixit on 7/1/20.
//  Copyright © 2020 Dixit. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
enum thoughtCategory : String {
    case serious = "Serious"
    case funny = "Funny"
    case crazy = "crazy"
    case popular = "popular"
    
}
class MainVC: UIViewController {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    // variable
    private var thoughtsArray = [Thought]()
    private var thoughtCollectionRef: CollectionReference!
    private var selectedCategory = thoughtCategory.funny.rawValue
    private var thoughtListener: ListenerRegistration!
    private var handle : AuthStateDidChangeListenerHandle?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        // tableView.rowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        thoughtCollectionRef = Firestore.firestore().collection(THOUGHT_REF)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle =  Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user ==  nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyboard.instantiateViewController(identifier: "LoginVC")
                self.present(loginVC, animated: true, completion: nil)
            }
            else {
                self.setListener()
            }
        })
        
        //print("hello")
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if thoughtListener != nil {
            thoughtListener.remove()
        }
    }
    @IBAction func CategoryChanged(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            selectedCategory = thoughtCategory.funny.rawValue
        case 1:
            selectedCategory = thoughtCategory.serious.rawValue
        case 2:
            selectedCategory = thoughtCategory.crazy.rawValue
        default:
            selectedCategory = thoughtCategory.popular.rawValue
        }
        thoughtListener.remove()
        setListener()
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signoutError as NSError {
            debugPrint("Error signing out \(signoutError.localizedDescription)")
        }
    }
    
    
    
    
    func setListener(){
        if selectedCategory == thoughtCategory.popular.rawValue {
            thoughtListener = thoughtCollectionRef
                .order(by: NUM_LIKES, descending: true)
                .addSnapshotListener { (snapshot, error) in
                    if let error = error {
                        debugPrint("ErrorFetching data\(error)")
                    } else {
                        self.thoughtsArray.removeAll()
                        self.thoughtsArray = Thought.parseData(snapshot: snapshot)
                        self.tableView.reloadData()
                    }
            }
        }
        else {
            thoughtListener = thoughtCollectionRef
                .whereField(CATEGORY, isEqualTo: selectedCategory)
                .order(by: TIMESTAMP, descending: true)
                .addSnapshotListener { (snapshot, error) in
                    if let error = error {
                        debugPrint("ErrorFetching data\(error)")
                    } else {
                        self.thoughtsArray.removeAll()
                        self.thoughtsArray = Thought.parseData(snapshot: snapshot)
                        self.tableView.reloadData()
                    }
            }
        }
    }
    
    
}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thoughtsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "thoughtCell", for: indexPath) as? ThoughtCell {
            cell.configureCell(thought: thoughtsArray[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        //print(numberOfSections(in: Int(tableView)))
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "newComment", sender: thoughtsArray[indexPath.row])
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newComment" {
            if let destinationVC = segue.destination as? CommentsVC {
                if let thought = sender as? Thought {
                    destinationVC.thought = thought
                }
            }
        }
    }
}
