//
//  AddThoughtVC.swift
//  Random_App
//
//  Created by Saurabh Dixit on 7/2/20.
//  Copyright © 2020 Dixit. All rights reserved.
//

import UIKit
import Firebase
//import FirebaseStorage

class AddThoughtVC: UIViewController {
    //variables
    private var selectedCategory = thoughtCategory.funny.rawValue
    //outlets
    @IBOutlet weak var categorySegment: UISegmentedControl!
    
    @IBOutlet weak var usernameTxt: UITextField!
    
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var thoughtTxtView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        thoughtTxtView.delegate = self
        // Do any additional setup after loading the view.
        postBtn.layer.cornerRadius = 4
        thoughtTxtView.layer.cornerRadius = 4
        thoughtTxtView.text = "My random thoughts...."
        thoughtTxtView.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
    }
    @IBAction func categoryChanged(_ sender: Any) {
        switch categorySegment.selectedSegmentIndex {
        case 0:
            selectedCategory = thoughtCategory.funny.rawValue
        case 1:
            selectedCategory = thoughtCategory.serious.rawValue
        default:
            selectedCategory = thoughtCategory.crazy.rawValue
        }
    }
    
    @IBAction func postBtnTapped(_ sender: Any) {
        guard let username = usernameTxt.text else {return}
        // Firestore.firestore().collection(THOUGHT_REF).addDocument(data:
        Firestore.firestore().collection(THOUGHT_REF).addDocument(data:
            [
               // CATEGORY: categorySegment!,
                CATEGORY : selectedCategory,
                NUM_COMMENT : 0,
                NUM_LIKES : 0,
                THOUGHT_TXT : thoughtTxtView.text!,
                TIMESTAMP : FieldValue.serverTimestamp(),
                USERNAME: username
            ])
        { (error) in
            if  let error = error {
                debugPrint("error adding documents\(error)")
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension AddThoughtVC: UITextViewDelegate{
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        thoughtTxtView.text = ""
        thoughtTxtView.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        return true
    }
}

