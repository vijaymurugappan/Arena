//
//  MatchMakingViewController.swift
//  Arena
//
//  Created by Vijay Murugappan Subbiah on 6/26/17.
//  Copyright © 2017 Vijay Murugappan Subbiah. All rights reserved.
//

import UIKit

class MatchMakingViewController: UIViewController {
    
    var uid = String()
    
    @IBOutlet weak var playerButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    
    @IBAction func playerButtonClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "Players", sender: self)
    }
    
    @IBAction func locationButtonClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "Locations", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "Players") {
            let newVc = segue.destination as! FindViewController
            newVc.uid = uid
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setcustomButton(button: playerButton)
        setcustomButton(button: locationButton)
    }
    
    func setcustomButton(button: UIButton) {
        button.layer.cornerRadius = 8.0
    }
    
}
