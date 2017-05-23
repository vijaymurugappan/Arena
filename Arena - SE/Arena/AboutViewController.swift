//
//  AboutViewController.swift
//  SubbiahNews
//  This file loads the User Portfolio Page in a WebView
//  Created by Vijay Murugappan on 11/04/17.
//  Copyright © 2017 cs.niu.edu. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    //MARK: OUTLET
    @IBOutlet weak var webView1: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //Getting the url file and loading the request
        let url = Bundle.main.url(forResource: "index", withExtension:"html")
        let URLObj = NSURLRequest(url: url!)
        webView1.loadRequest(URLObj as URLRequest)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
