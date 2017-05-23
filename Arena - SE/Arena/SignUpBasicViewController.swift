//
//  SignUpViewController.swift
//  Arena
//  This is a user sign up basic information page
//  Created by Vijay Murugappan Subbiah on 4/23/17.
//  Copyright © 2017 Vijay Murugappan Subbiah. All rights reserved.
//

import UIKit


class SignUpBasicViewController: UIViewController,UITextFieldDelegate {
    
//OUTLETS
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var sexTextField: UITextField!
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//TEXT FIELD DELEGATE METHODS
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        ageTextField.resignFirstResponder()
        sexTextField.resignFirstResponder()
        contactTextField.resignFirstResponder()
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "signup") {
            //sending the information to the next sign up view controller
            let vc2 = segue.destination as! SignUpSportViewController
            vc2.age = ageTextField.text!
            vc2.name = nameTextField.text!
            vc2.sex = sexTextField.text!
            vc2.number = contactTextField.text!
            vc2.username = usernameTextField.text!
            vc2.password = passwordTextField.text!
        }
    }

}
