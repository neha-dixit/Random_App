//
//  CreateUserVC.swift
//  Random_App
//
//  Created by Saurabh Dixit on 7/11/20.
//  Copyright © 2020 Dixit. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class CreateUserVC: UIViewController {

    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var pwdTxt: UITextField!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var createBtn: UIButton!
    
    @IBOutlet weak var cancelBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        createBtn.layer.cornerRadius = 10
        cancelBtn.layer.cornerRadius = 10
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func createBtnTapped(_ sender: Any) {
        guard let email = emailTxt.text,
            let pwd = pwdTxt.text,
            let username = usernameTxt.text else { return }
        Auth.auth().createUser(withEmail: email , password: pwd) { (user, error) in
            if let error = error {
                debugPrint("Error whie creating user\(error.localizedDescription)")
        }
            let changeRequest = user?.user.createProfileChangeRequest()
            changeRequest?.displayName = username
            changeRequest?.commitChanges(completion: { (error) in
                if let error = error {
                    debugPrint(error.localizedDescription)
                }
            })
            guard let userId = user?.user.uid else { return }
            Firestore.firestore().collection(USERS_REF).document(userId).setData([
                USERNAME : username,
                DATE_CREATED: FieldValue.serverTimestamp()
                ])
            { (error) in
                if let error = error {
                    debugPrint(error.localizedDescription)
                }
                else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
    }
    }

    @IBAction func cancelBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
