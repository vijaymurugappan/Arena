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
import FacebookLogin
import FacebookCore
import GoogleSignIn

class HomeViewController: UIViewController,GIDSignInUIDelegate {
    
    //VARIABLES
    var uid = String()
    
    //OUTLETS
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginbuttonClicked: UIButton!
    @IBOutlet weak var signButtonClicked: UIButton!
    @IBOutlet weak var domainLabel: UILabel!
    
    //ACTION
    @IBAction func loginClicked(_ sender: UIButton) {
        //Block which authenticates the user with the provided email and password if exists in the google cloud database
        let loginID = loginTextField.text! + domainLabel.text!
        FIRAuth.auth()?.signIn(withEmail: loginID, password: passwordTextField.text!, completion: { (user, error) in
            if error == nil {
                self.loginbuttonClicked.setTitle("Logged In", for: .normal)
                self.uid = (user?.uid)! //Unique user ID
                self.performSegue(withIdentifier: "profile", sender: self)
            }
            else
            {
                let alertVC = UIAlertController(title: "Incorrect Login",message: error?.localizedDescription,preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok",style:.default,handler: nil)
                alertVC.addAction(okAction)
                self.present(alertVC,animated: true,completion: nil)
            }
        })
    }
    
    //Places the cursor at login text field after loading
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton = LoginButton(frame: CGRect(x: 49, y: 406, width: 222, height: 30), readPermissions: [.publicProfile, .email, .userFriends])
        loginButton.layer.cornerRadius = 8.0
        view.addSubview(loginButton)
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        let gloginButton = GIDSignInButton(frame: CGRect(x: 49, y: 446, width: 222, height: 30))
        gloginButton.style = .wide
        gloginButton.layer.cornerRadius = 8.0
        view.addSubview(gloginButton)
        setcustomTextField(textfield: loginTextField, placeholdername: "Login ID")
        setcustomTextField(textfield: passwordTextField, placeholdername: "Password")
        setcustomButton(button: loginbuttonClicked)
        setcustomButton(button: signButtonClicked)
        if let accessToken = AccessToken.current {
            print(accessToken.appId)
        }
    }
    
    func setcustomTextField(textfield: UITextField, placeholdername: String) {
        textfield.layer.borderWidth = 1.0
        textfield.layer.cornerRadius = 8.0
        textfield.layer.borderColor = UIColor.white.cgColor
        textfield.attributedPlaceholder = NSAttributedString(string: placeholdername, attributes: [NSForegroundColorAttributeName: UIColor.white])
    }
    
    func setcustomButton(button: UIButton) {
        button.layer.cornerRadius = 8.0
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
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
            //op
        }
        else {
            print("\(error.localizedDescription)")
        }
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

