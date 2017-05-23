//
//  User.swift
//  Arena
//
//  Created by Vijay Murugappan Subbiah on 4/24/17.
//  Copyright © 2017 Vijay Murugappan Subbiah. All rights reserved.
//

import UIKit

    //Creating an Object for Places containing their details
    class User: NSObject {
        //Defining Data Types for the Data in the Data Set
        var Name:String!
        var Age:String!
        var Sex:String!
        var Contact:String!
        var Username:String!
        var Password:String!
        var Sports:String!
        var Day:String!
        var Time:String!
        var Bowling:String!
        var Badminton:String!
        var Soccer:String!
        var uid:String!
        
        //Creating a Function to assign the values to hold the incoming values from the data sets accordingly
        init(name: String, age: String, sex: String, contact: String, username: String, password: String, sports: String, day: String, time: String, bowling: String, badminton: String, soccer: String) {
            
            self.Name = name
            self.Age = age
            self.Sex = sex
            self.Contact = contact
            self.Username = username
            self.Password = password
            self.Sports = sports
            self.Day = day
            self.Time = time
            self.Bowling = bowling
            self.Badminton = badminton
            self.Soccer = soccer
           // print(name)
        }
        func id(uid: String) {
            self.uid = uid
        }
    
    }
