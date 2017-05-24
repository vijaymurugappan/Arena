//
//  SignUpViewController.swift
//  Arena
//  This is a user sign up basic information page
//  Created by Vijay Murugappan Subbiah on 4/23/17.
//  Copyright © 2017 Vijay Murugappan Subbiah. All rights reserved.
//

import UIKit
import QuartzCore

class SignUpBasicViewController: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    
//OUTLETS
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var sexTextField: UITextField!
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var saveButtonClicked: UIButton!
    @IBOutlet weak var domainLabel: UILabel!
    
    let pickerData = ["M","F"]
    let pickerViews = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setcustomTextField(textfield: nameTextField, placeholdername: "Full Name")
        setcustomTextField(textfield: ageTextField, placeholdername: "Age")
        setcustomTextField(textfield: sexTextField, placeholdername: "Sex")
        setcustomTextField(textfield: contactTextField, placeholdername: "Phone Number")
        setcustomTextField(textfield: usernameTextField, placeholdername: "User Name")
        setcustomTextField(textfield: passwordTextField, placeholdername: "Password")
        setcustomButton(button: saveButtonClicked)
        nameTextField.addTarget(self, action: #selector(enableButton), for: .editingChanged)
        ageTextField.addTarget(self, action: #selector(enableButton), for: .editingChanged)
        sexTextField.addTarget(self, action: #selector(enableButton), for: .editingChanged)
        contactTextField.addTarget(self, action: #selector(enableButton), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(enableButton), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(enableButton), for: .editingChanged)
        saveButtonClicked.isEnabled = false
        saveButtonClicked.alpha = 0.5
        sexTextField.inputView = pickerViews
        ageTextField.keyboardType = UIKeyboardType.numberPad
        contactTextField.keyboardType = UIKeyboardType.numberPad
        pickerViews.dataSource = self
        pickerViews.delegate = self
    }
    
    func enableButton(_textfield: UITextField) {
        if(_textfield.text?.characters.count == 1) {
            if(_textfield.text?.characters.first == " ") {
                _textfield.text = ""
                return
            }
        }
        guard(!(nameTextField.text?.isEmpty)! && !(ageTextField.text?.isEmpty)! && !(sexTextField.text?.isEmpty)! && !(contactTextField.text?.isEmpty)! && !(usernameTextField.text?.isEmpty)! && !(passwordTextField.text?.isEmpty)!)
        else {
            saveButtonClicked.isEnabled = false
            saveButtonClicked.alpha = 0.5
            return
        }
        saveButtonClicked.isEnabled = true
        saveButtonClicked.alpha = 1.0
    }
    
    func setcustomTextField(textfield: UITextField, placeholdername: String) {
        textfield.backgroundColor = UIColor.clear
        textfield.layer.borderWidth = 1.0
        textfield.layer.cornerRadius = 8.0
        textfield.layer.borderColor = UIColor.white.cgColor
        textfield.attributedPlaceholder = NSAttributedString(string: placeholdername, attributes: [NSForegroundColorAttributeName: UIColor.white])
    }
    
    func setcustomButton(button: UIButton) {
        button.layer.cornerRadius = 8.0
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
            let userID = usernameTextField.text! + domainLabel.text!
            let vc2 = segue.destination as! SignUpSportViewController
            vc2.age = ageTextField.text!
            vc2.name = nameTextField.text!
            vc2.sex = sexTextField.text!
            vc2.number = contactTextField.text!
            vc2.username = userID
            vc2.password = passwordTextField.text!
        }
    }
    
    //PICKER VIEW DELEGATE AND DATA SOURCE METHODS
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sexTextField.text = pickerData[row]
    }


}
