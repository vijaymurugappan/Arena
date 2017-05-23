//
//  AuthorViewController.swift
//  Arena
//
//  Created by Vijay Murugappan Subbiah on 5/23/17.
//  Copyright © 2017 Vijay Murugappan Subbiah. All rights reserved.
//

import UIKit

class AuthorViewController: UIViewController {

    @IBOutlet weak var aboutButtonClicked: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setcustomButton(button: aboutButtonClicked)
    }

    func setcustomButton(button: UIButton) {
        button.layer.cornerRadius = 8.0
    }
    
}
