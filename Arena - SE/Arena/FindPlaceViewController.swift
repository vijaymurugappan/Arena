//
//  FindPlaceViewController.swift
//  Arena
//
//  Created by Vijay Murugappan Subbiah on 6/26/17.
//  Copyright © 2017 Vijay Murugappan Subbiah. All rights reserved.
//

import UIKit

class FindPlaceViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var ratingTextField: UITextField!
    @IBOutlet weak var sportTextField: UITextField!
    @IBOutlet weak var radiusTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setcustomTextField(textfield: ratingTextField, placeholdername: "RATING")
        setcustomTextField(textfield: sportTextField, placeholdername: "SPORT")
        setcustomTextField(textfield: radiusTextField, placeholdername: "RADIUS")
        setcustomButton(button: searchButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        ratingTextField.resignFirstResponder()
        radiusTextField.resignFirstResponder()
        sportTextField.resignFirstResponder()
        return true
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
    
    @IBAction func searchButtonClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "loc", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "loc") {
            let vcTemp = segue.destination as! PlaceMapViewController
            vcTemp.radius = radiusTextField.text!
            vcTemp.rating = ratingTextField.text!
            vcTemp.game = sportTextField.text!
        }
    }

}
