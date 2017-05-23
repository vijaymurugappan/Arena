//
//  ViewController.swift
//  Arena
//  Application Content - Crowd Sourcing Application Prototype
//  This application is a prototype of my application which is a crowdsourcing application where the model is the user itself who signs into this application and they can find opponents based on their skills and information and contact them for games
//  Created by Vijay Murugappan Subbiah on 4/24/17.
//  Copyright © 2017 Vijay Murugappan Subbiah. All rights reserved.
//

import UIKit
import Firebase //Firebase Pod
import FirebaseAuth //Firebase authentication for login
import QuartzCore
class HomeViewController: UIViewController {
    
    //VARIABLES
    var uid = String()
    
    //OUTLETS
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginbuttonClicked: UIButton!
    @IBOutlet weak var signButtonClicked: UIButton!
    
    //ACTION
    @IBAction func loginClicked(_ sender: UIButton) {
        //Block which authenticates the user with the provided email and password if exists in the google cloud database
        FIRAuth.auth()?.signIn(withEmail: loginTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
            if error == nil {
                self.loginbuttonClicked.setTitle("Logged In", for: .normal)
                self.uid = (user?.uid)! //Unique user ID
                self.performSegue(withIdentifier: "profile", sender: self)
            }
            else
            {
                print("Incorrect Login")
                print(error ?? 0)
            }
        })
    }
    
    //Places the cursor at login text field after loading
    override func viewDidLoad() {
        super.viewDidLoad()
        customUI()
        loginTextField.becomeFirstResponder()
    }
    
    func customUI() {
        loginTextField.layer.borderWidth = 1.0
        loginTextField.layer.cornerRadius = 8.0
        loginTextField.layer.borderColor = UIColor.white.cgColor
        loginTextField.attributedPlaceholder = NSAttributedString(string: "Login ID", attributes: [NSForegroundColorAttributeName: UIColor.white])
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.cornerRadius = 8.0
        passwordTextField.layer.borderColor = UIColor.white.cgColor
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.white])
        loginbuttonClicked.layer.cornerRadius = 8.0
        signButtonClicked.layer.cornerRadius = 8.0
    }
    
    //Dismisses keyboard when touched outside
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    //Dismisses Keyboard when pressed return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        loginTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    //Transfering the ID to different view controllers present among the tab bar controllers
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "profile") {
            let tabctrl = segue.destination as! UITabBarController
            let nav = tabctrl.viewControllers![0] as! UINavigationController
            let vc = nav.viewControllers[0] as! ProfileViewController
            vc.uid = uid
            let nav2 = tabctrl.viewControllers![1] as! UINavigationController
            let vc1 = nav2.viewControllers[0] as! FindViewController
            vc1.uid = uid
        }
    }
}

