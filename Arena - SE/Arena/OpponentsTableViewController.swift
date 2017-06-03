//
//  OpponentsTableViewController.swift
//  Arena
//  This is a table view controller having refined from the searches, the names of the opponents
//  Created by Vijay Murugappan Subbiah on 4/25/17.
//  Copyright © 2017 Vijay Murugappan Subbiah. All rights reserved.
//

import UIKit
import Firebase
class OpponentsTableViewController: UITableViewController {
    
    //Object Handler
    let users = [User]()
    
    //Variables
    var nameArray = [String]()
    var id = [String]()
    var keyArray = [String]()
    var name = String()
    
    //caling prepare key during load
    override func viewDidLoad() {
        super.viewDidLoad()
        //definesPresentationContext = true
        prepareKey()
    }
    //This function extracts the keys and appends it into a key array
    func prepareKey() {
        let ref = FIRDatabase.database().reference()
        ref.observe(.value, with: {(snapshot) in
            if let result = snapshot.children.allObjects as? [FIRDataSnapshot] {
                let counter = result.count
                //print(result[1].key)
                for i in 0...(counter-1) {
                    self.keyArray.append(result[i].key)
                }
                self.fetchID() // retreiving ID function
            }
        })
    }
    //This function from the keys array retrieving the names and if it matches with the names of the opponent then their id is fetched
    func fetchID() {
        let ref = FIRDatabase.database().reference()
        for key in keyArray {
            let chldref = ref.child(key)
            chldref.observe(.value, with: {(snappy) in
                if let res = snappy.children.allObjects as? [FIRDataSnapshot] {
                    for name in self.nameArray {
                        self.name = res[3].value as! String
                        if(name == (self.name)) {
                            self.id.append(res[10].value as! String)
                        }
                    }
                }
                
            })
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count //count of the number of names
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath)
        //        let use:User = users[indexPath.item]
        print(nameArray)
        cell.textLabel?.text = nameArray[indexPath.item] // opponent names
        return cell
    }
    
    //sending ID back to the profile view controller to know the details about our opponents
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "opponentprofile")
        {
            let destVC = segue.destination as! ProfileViewController
            if let indexpath = self.tableView.indexPathForSelectedRow {
                destVC.uid = id[indexpath.item]
            }
        }
    }
    
    
}
