//
//  FindViewController.swift
//  Arena
//  This viewcontroller is for the user to find appropriate match-ups based on his specifications and skills
//  Created by Vijay Murugappan Subbiah on 4/25/17.
//  Copyright © 2017 Vijay Murugappan Subbiah. All rights reserved.
//

import UIKit
import Firebase

class FindViewController: UIViewController,UITextFieldDelegate {

    //VARIABLES
    var age = Int()
    var temp = Int()
    var badskill = Int()
    var bowskill = Int()
    var socskill = Int()
    var strage = String()
    var strbad = String()
    var strbow = String()
    var strsoc = String()
    var chosenUID = String()
    var sex = String()
    var sport = String()
    var uid = String()
    var pid = String()
    var ageArray = [Int]()
    var sexArray = [String]()
    var uidArray = [String]()
    var badskillArray = [Int]()
    var bowskillArray = [Int]()
    var socskillArray = [Int]()
    var sportArray = [String]()
    var chosenUIDArray = [String]()
    var chldref = FIRDatabaseReference()
    var count = Int()
    
    //OUTLETS
    @IBOutlet weak var selectedSportTextField: UITextField!
    @IBOutlet weak var skillLabel: UILabel!
    @IBOutlet weak var skillSlider: UISlider!
    @IBOutlet weak var selectedAgeTextField: UITextField!
    @IBOutlet weak var selectedSexTextField: UITextField!
    @IBOutlet weak var searchGameSwitch: UISwitch!
    @IBOutlet weak var searchInformationSwitch: UISwitch!
    @IBOutlet weak var findButtonClicked: UIButton!
    
    //ACTIONS
    //sliders
    @IBAction func sliderChanged(_ sender: UISlider) {
        let temp = Int(sender.value)
        skillLabel.text = String(temp)
    }
    //switches
    @IBAction func gameSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            selectedSportTextField.isEnabled = true
            skillSlider.isEnabled = true
            let t = Int(skillSlider.value) //setting default value
            skillLabel.text = String(t)
            selectedSexTextField.isEnabled = false
            selectedAgeTextField.isEnabled = false
            searchInformationSwitch.isOn = false
        }
        else {
            selectedAgeTextField.isEnabled = true
            selectedSexTextField.isEnabled = true
            skillSlider.isEnabled = false
            skillLabel.text = String(0) //setting 0 value
            selectedSportTextField.isEnabled = false
            searchInformationSwitch.isOn = true
        }
    }
    
    @IBAction func infoSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            selectedAgeTextField.isEnabled = true
            selectedSexTextField.isEnabled = true
            skillSlider.isEnabled = false
            skillLabel.text = String(0)
            selectedSportTextField.isEnabled = false
            searchGameSwitch.isOn = false
        }
        else {
            selectedSportTextField.isEnabled = true
            skillSlider.isEnabled = true
            let t = Int(skillSlider.value)
            skillLabel.text = String(t)
            selectedSexTextField.isEnabled = false
            selectedAgeTextField.isEnabled = false
            searchGameSwitch.isOn = true
        }
    }
    
    //when the search button is clicked after giving the criteria's for the search
    @IBAction func searchSelected(_ sender: UIButton) {
        if(searchGameSwitch.isOn) { // if switch is on
            for str in sportArray {
                //print(str)
                if(str == "Badminton") { //if badminton
                    for skl in badskillArray {
                        //print(skl)
                if(selectedSportTextField.text == str && Int(skillLabel.text!)! == skl) { //checking whether there is a match with the database value
                    for uidd in uidArray {
                    temp = 1
                    transferData(str: str,skl: skl,temp: temp,uidd: uidd) //if yes transfer it to a function
                    //print("exit transfer")
                    }
                    break
                        }
                    }
                 //   self.performSegue(withIdentifier: "opponent", sender: self)
                    //print("exit loop")
                    break
                }
                if(str == "Soccer") { //if soccer
                    for skl in socskillArray {
                        if(selectedSportTextField.text == str && Int(skillLabel.text!)! == skl) {
                            for uidd in uidArray {
                            temp = 2
                            transferData(str: str,skl: skl,temp: temp,uidd: uidd)
                        }
                            break
                        }
                    }
                    break
                }
                if(str == "Bowling") { //if bowling
                    for skl in bowskillArray {
                        if(selectedSportTextField.text == str && Int(skillLabel.text!)! == skl) {
                            for uidd in uidArray {
                            temp = 3
                            transferData(str: str,skl: skl,temp: temp,uidd: uidd)
                            }
                            break
                        }
                    }
                    break
                }
            }
        }
                if(searchInformationSwitch.isOn) { //if another switch is on
                    for a in ageArray {
                        for s in sexArray {
                            if(Int(selectedAgeTextField.text!)! == a && selectedSexTextField.text == s) {
                                transferData1(str: s, a: a)
                                break
                            }
                        }
                        break
                    }
                }
        //print("exit switch")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setcustomTextField(textfield: selectedSportTextField, placeholdername: "Sport Name")
        setcustomTextField(textfield: selectedAgeTextField, placeholdername: "Age")
        setcustomTextField(textfield: selectedSexTextField, placeholdername: "Sex (M/F)")
        setcustomButton(button: findButtonClicked)
        let t = Int(skillSlider.value)
        skillLabel.text = String(t)
        searchGameSwitch.isOn = true
        searchInformationSwitch.isOn = false
        selectedAgeTextField.isEnabled = false
        selectedSexTextField.isEnabled = false
        fetchKey() // retreiving the keys of the values stored in the snapshot database before the view loads
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
    
    func fetchKey() {
        let ref = FIRDatabase.database().reference()
        ref.observe(.value, with: {(snapshot) in
            if let res = snapshot.children.allObjects as? [FIRDataSnapshot] {
                let counter = res.count
                for i in 0...(counter-1) { // from 0 to count-1
                self.uidArray.append(res[i].key) //appending keys to the array
                }
             self.fetchData() //using the key fetch the data
            }
        })
    }
    //this function retreives the user data using the key values
    func fetchData() {
        let ref = FIRDatabase.database().reference()
        for uidd in uidArray { //looping the key values
            let chldref = ref.child(uidd)
        chldref.observe(.value, with: {(FIRDataSnapshot) in //retreiving files from the database
            if let results = FIRDataSnapshot.children.allObjects as? [FIRDataSnapshot] {
                self.strage = results[1].value as! String
                self.age = Int(self.strage)!
                self.ageArray.append(self.age)
                    self.sex = results[8].value as! String
                self.sexArray.append(self.sex)
                    self.strbad = results[2].value as! String
                self.badskill = Int(self.strbad)!
                self.badskillArray.append(self.badskill)
                    self.strbow = results[3].value as! String
                self.bowskill = Int(self.strbow)!
                self.bowskillArray.append(self.bowskill)
                    self.strsoc = results[9].value as! String
                self.socskill = Int(self.strsoc)!
                self.socskillArray.append(self.socskill)
                    self.sport = results[10].value as! String
                self.sportArray.append(self.sport)
                //print(self.sportArray)
                //print(self.ageArray)
                //print(self.sexArray)
            }
        })
        }
    }
    //transferred data function from the switch 2 which searches based on the age and sex specified by the user
    func transferData1(str:String,a:Int) {
        let ref = FIRDatabase.database().reference()
        for uidd in uidArray {
            let chldref = ref.child(uidd)
        chldref.observe(.value, with: {(FIRDataSnapshot) in
            if let results = FIRDataSnapshot.children.allObjects as? [FIRDataSnapshot] {
                self.pid = results[11].value as! String
                if(self.pid == self.uid)
                {
                    //Do nothing
                }
                else {
                    self.strage = results[1].value as! String
                self.age = Int(self.strage)!
                    self.sex = results[8].value as! String
                    if(self.age == a && self.sex == str) {
                        self.chosenUID = results[11].value as! String
                        self.chosenUIDArray.append(self.chosenUID) //append uid if matches
                }
                }
                        self.performSegue(withIdentifier: "opponent", sender: self) //navigation
            }
        })
        }
    }
    
    //transferred data from the switch 1 while searches based on the skill level of the sport and that sport name specified by the user
    func transferData(str:String,skl:Int,temp:Int,uidd:String) {
        let ref = FIRDatabase.database().reference()
            //print("enter array")
            self.chldref = ref.child(uidd)
        chldref.observe(.value, with: {(FIRDataSnapshot)  in
            if let results = FIRDataSnapshot.children.allObjects as? [FIRDataSnapshot] {
                self.count += 1
                if(temp == 1) { // reference number passed to identify the sport and skill
                    self.pid = results[11].value as! String
                    if(self.pid == self.uid) // not for showing the user's own stats and profile
                    {
                        //Do nothing
                    }
                    else {
                    self.strbad = results[2].value as! String
                    self.badskill = Int(self.strbad)!
                    self.sport = results[10].value as! String
                    //print(self.sport)
                    if(self.badskill == skl && self.sport == str) {
                        self.chosenUID = results[11].value as! String
                        //print(self.chosenUID)
                        self.chosenUIDArray.append(self.chosenUID)
                        //print(self.chosenUIDArray)
                    }
                    }
                }
                
                if(temp == 2) {
                    self.pid = results[11].value as! String
                    if(self.pid == self.uid)
                    {
                        //Do nothing
                    }
                    else {
                    self.strbow = results[3].value as! String
                    self.bowskill = Int(self.strbow)!
                    self.sport = results[10].value as! String
                    if(self.bowskill == skl && self.sport == str) {
                        self.chosenUID = results[11].value as! String
                        self.chosenUIDArray.append(self.chosenUID)
                        }
                    }
                }
                if(temp == 3) {
                    self.pid = results[11].value as! String
                    if(self.pid == self.uid)
                    {
                        //Do nothing
                    }
                    else {
                    self.strsoc = results[9].value as! String
                    self.socskill = Int(self.strsoc)!
                    self.sport = results[10].value as! String
                    if(self.socskill == skl && self.sport == str) {
                        self.chosenUID = results[11].value as! String
                        self.chosenUIDArray.append(self.chosenUID)
                        }
                    }
                }
            }
            if(self.count == self.uidArray.count) {
            //print("exiting completion handler")
            self.performSegue(withIdentifier: "opponent", sender: self)
            }
            })
            //print("exit array")
        //print("exit fn")
    }
    
    //TEXT FIELD DELEGATE METHODS
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        selectedAgeTextField.resignFirstResponder()
        selectedSexTextField.resignFirstResponder()
        selectedSportTextField.resignFirstResponder()
        return true
    }
    
    //passing name array from this view controller to the table view controller to display opponents
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if(segue.identifier == "opponent") {
//                let nvc2 = segue.destination as! UINavigationController
//                let vc2 = nvc2.viewControlleters[0] as! OpponentsTableViewController
                let vc2 = segue.destination as! MapViewController
                //print("FINAL UID ARRAY IS \(chosenUIDArray)")
                vc2.uidArray = chosenUIDArray
            }
        }
    
}



