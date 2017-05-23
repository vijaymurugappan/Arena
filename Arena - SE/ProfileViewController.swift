//
//  ProfileViewController.swift
//  Arena
//  This view controller shows the profile page of the current user
//  Created by Vijay Murugappan Subbiah on 4/24/17.
//  Copyright © 2017 Vijay Murugappan Subbiah. All rights reserved.
//

import UIKit
import Firebase
import MessageUI // For integrating iOS messaging in application
class ProfileViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MFMailComposeViewControllerDelegate {
    
    //Object Handler
    var users = [User]()
    
    //VARIABLES
    let picker = UIImagePickerController()
    var uid = String()
    var uidArray = [String]()
    var contactnum = String()
    
    //OUTLETS
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var fullLabel: UILabel!
    @IBOutlet weak var sportLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var badmintonLabel: UILabel!
    @IBOutlet weak var bowlingLabel: UILabel!
    @IBOutlet weak var soccerLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    
    //ACTIONS
    //This function is implemented when the call button is tapped which calls the number from the phone
    @IBAction func callTapped(_ sender: Any) {
        let myURL:NSURL = URL(string: "tel://\(self.contactnum)")! as NSURL
        UIApplication.shared.open(myURL as URL, options: [:], completionHandler: nil)
        //Using alert since we are running on a simulator
        let alertController = UIAlertController(title: "Calling..", message: self.contactnum, preferredStyle: .alert)
        
        let dismissButton = UIAlertAction(title: "Dismiss", style: .cancel, handler: {
            
            (alert: UIAlertAction!) -> Void in
        })
        alertController.addAction(dismissButton)
        self.present(alertController, animated: true, completion: nil)

    }
    //This function is implemented when the message button is tapped which sends out a text to the number from the phone
    @IBAction func messageTapped(_ sender: UIButton) {
        if(MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "Hey are you available for a game?"
            controller.recipients = [self.contactnum]
            controller.messageComposeDelegate = self as? MFMessageComposeViewControllerDelegate
            self.present(controller, animated: true, completion: nil)
        }
        else {
            self.noMessage()
        }
    }
    
    //This button click triggers an action sheet containing two options one which is camera which allows the user to click pictures and add as a profile picture and the other one is photo library which it enables the user to choose a photo from his photo library for his profile picture
    @IBAction func uploadPicture(_ sender: UIButton) {
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle:.actionSheet)
        
        let galleryAction = UIAlertAction(title: "Photo Library", style: .default, handler: {(alert: UIAlertAction!) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            self.picker.allowsEditing = false
            self.picker.sourceType = .photoLibrary //photo library
            self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.present(self.picker, animated: true, completion: nil)
            }
            else {
                self.noLib()
            }
        })
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {(alert: UIAlertAction!) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.picker.allowsEditing = false
            self.picker.sourceType = .camera //camera
            self.picker.cameraCaptureMode = .photo
            self.picker.modalPresentationStyle = .fullScreen
            self.present(self.picker, animated: true, completion: nil)
            }
            else {
                self.noCamera()
            }
        })
        
        optionMenu.addAction(galleryAction)
        optionMenu.addAction(cameraAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    //else functions which triggers alert
    func noMessage()
    {
        let alertVC = UIAlertController(title: "No Messaging",message: "Sorry, this device has no Messaging capabilities",preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
        alertVC.addAction(okAction)
        present(alertVC,animated: true,completion: nil)
    }
    
    func noLib()
    {
        let alertVC = UIAlertController(title: "No Photo Library",message: "Sorry, this device has no photo library",preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
        alertVC.addAction(okAction)
        present(alertVC,animated: true,completion: nil)
    }
    
    func noCamera()
    {
        let alertVC = UIAlertController(title: "No Camera",message: "Sorry, this device has no camera",preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
        alertVC.addAction(okAction)
        present(alertVC,animated: true,completion: nil)
    }
    
    //Image Picker Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var image = UIImage()
        image = info[UIImagePickerControllerOriginalImage] as! UIImage
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //the values are getting updated from the cloud database before the view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        let ref = FIRDatabase.database().reference() //creating root referenence
        let chdref = ref.child(uid) //creating path for child
        chdref.observe(.value, with: {(FIRDataSnapshot) in
            if let result = FIRDataSnapshot.children.allObjects as? [FIRDataSnapshot] {
                self.tabBarController?.title = result[3].value as? String
                self.userLabel.text = result[10].value as? String
                self.fullLabel.text = result[3].value as? String
                self.sportLabel.text = result[9].value as? String
                self.timeLabel.text = result[6].value as? String
                self.dayLabel.text = result[5].value as? String
                self.badmintonLabel.text = result[1].value as? String
                self.bowlingLabel.text = result[2].value as? String
                self.soccerLabel.text = result[8].value as? String
                self.contactnum = (result[4].value as? String)!
            }
        })
    }

}
