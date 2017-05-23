//
//  SignUpSportViewController.swift
//  Arena
//  This is the final phase of user creation which contains user sport's information
//  Created by Vijay Murugappan Subbiah on 4/23/17.
//  Copyright © 2017 Vijay Murugappan Subbiah. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
class SignUpSportViewController: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    
//FIREBASE REFERENCES
let rootref = FIRDatabase.database().reference()
    
//VARIABLES
    let pickerData = Calendar.current.weekdaySymbols
    var name = String()
    var age = String()
    var sex = String()
    var number = String()
    var username = String()
    var password = String()
    var users = [User]() // Handler for the object
    var pickerViews = UIPickerView() // Picker View
    let timePicker = UIDatePicker() // Date Picker
    
//OUTLETS
    @IBOutlet weak var sportTextField: UITextField!
    @IBOutlet weak var dayTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var badmintonSkill: UILabel!
    @IBOutlet weak var bowlingSkill: UILabel!
    @IBOutlet weak var soccerSkill: UILabel!
    @IBOutlet weak var badmintonSlider: UISlider!
    @IBOutlet weak var soccerSlider: UISlider!
    @IBOutlet weak var bowlingSlider: UISlider!
    
//ACTIONS
    @IBAction func registerClicked(_ sender: UIButton) {
        //Appending to the User object
        self.users.append(User(name: self.name, age: self.age, sex: self.sex, contact: self.number, username: self.username, password: self.password, sports: self.sportTextField.text!, day: self.dayTextField.text!, time: self.timeTextField.text!, bowling: self.bowlingSkill.text!, badminton: self.badmintonSkill.text!, soccer: self.soccerSkill.text!))
        for item in users  {
            //New user creating using firebase clouse database with username and password
        FIRAuth.auth()?.createUser(withEmail: item.Username, password: item.Password, completion: { (user, error) in
            if(error == nil)
            { //From the user object extracting the files and storing it in the database
                let descref = self.rootref.child((user?.uid)!)
                let nameref = descref.child("name")
                let ageref = descref.child("age")
                let sexref = descref.child("sex")
                let contactref = descref.child("number")
                let idref = descref.child("uid")
                let sportsref = descref.child("sports")
                let dayref = descref.child("preferred day")
                let timeref = descref.child("preferred time")
                let badmintonref = descref.child("badminton skill")
                let bowlingref = descref.child("bowling skill")
                let soccerref = descref.child("soccer skill")
                //print(item.Name)
                nameref.setValue(item.Name)
                ageref.setValue(item.Age)
                sexref.setValue(item.Sex)
                contactref.setValue(item.Contact)
                idref.setValue(user?.uid)
                sportsref.setValue(item.Sports)
                dayref.setValue(item.Day)
                timeref.setValue(item.Time)
                badmintonref.setValue(item.Badminton)
                bowlingref.setValue(item.Bowling)
                soccerref.setValue(item.Soccer)
                item.id(uid: (user?.uid)!)
            }
            else {
                print(error ?? 0)
            }
        })
        }
    }
    //User defined function to format the time to be displayed in the date picker view and store it in the textfield when changed
    func datePickerChanged(_ sender: UIDatePicker) {
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        timeTextField.text = timeFormatter.string(from: sender.date)
    }
    
    //Three Switches
    @IBAction func badmintonSwitch(_ sender: UISwitch) {
        if sender.isOn {
            badmintonSkill.isHidden = false
            badmintonSlider.isHidden = false
            let t = Int(badmintonSlider.value)
            badmintonSkill.text = String(t)
        }
        else {
            badmintonSkill.isHidden = true
            badmintonSlider.isHidden = true
            badmintonSkill.text = String(0)
        }
    }
    @IBAction func soccerSwitch(_ sender: UISwitch) {
        if sender.isOn {
            soccerSkill.isHidden = false
            soccerSlider.isHidden = false
            let t = Int(soccerSlider.value)
            soccerSkill.text = String(t)
        }
        else {
            soccerSkill.isHidden = true
            soccerSlider.isHidden = true
            soccerSkill.text = String(0)
        }
    }
    @IBAction func bowlingSwitch(_ sender: UISwitch) {
        if sender.isOn {
            bowlingSkill.isHidden = false
            bowlingSlider.isHidden = false
            let t = Int(bowlingSlider.value)
            bowlingSkill.text = String(t)
        }
        else {
            bowlingSkill.isHidden = true
            bowlingSlider.isHidden = true
            bowlingSkill.text = String(0)
        }
    }
    //Three sliders
    @IBAction func badmintonSlideAct(_ sender: UISlider) {
        let temp = Int(sender.value)
        badmintonSkill.text = String(temp)
    }
    @IBAction func soccerSlideAct(_ sender: UISlider) {
        let temp = Int(sender.value)
        soccerSkill.text = String(temp)
    }
    @IBAction func bowlingSlideAct(_ sender: UISlider) {
        let temp = Int(sender.value)
        bowlingSkill.text = String(temp)
    }
    
//TEXT FIELD DELEGATE METHODS
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sportTextField.resignFirstResponder()
        dayTextField.resignFirstResponder()
        timeTextField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        badmintonSkill.isHidden = true
        badmintonSlider.isHidden = true
        soccerSkill.isHidden = true
        soccerSlider.isHidden = true
        bowlingSkill.isHidden = true
        bowlingSlider.isHidden = true
        pickerViews.delegate = self
        pickerViews.dataSource = self
        dayTextField.inputView = pickerViews // Changing the input view to pickerview
        timePicker.datePickerMode = UIDatePickerMode.time
        timeTextField.inputView = timePicker // Changing the input view to datapickerview
        timePicker.addTarget(self, action: #selector(self.datePickerChanged(_:)), for: .valueChanged)
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
        dayTextField.text = pickerData[row]
    }
    
}