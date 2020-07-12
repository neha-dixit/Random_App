//
//  LoginVC.swift
//  Random_App
//
//  Created by Saurabh Dixit on 7/11/20.
//  Copyright © 2020 Dixit. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
class LoginVC: UIViewController {

    
    @IBOutlet weak var emailTxtField: UITextField!
    
    @IBOutlet weak var pwdTxtField: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var createUserBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        loginBtn.layer.cornerRadius = 10
        createUserBtn.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginBtnTapped(_ sender: Any) {
        guard let email = emailTxtField.text,
            let pwd = pwdTxtField.text else { return }
        Auth.auth().signIn(withEmail: email, password: pwd) { (user, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            }
            else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func createUserBtnTapped(_ sender: Any) {
    }
    
}
