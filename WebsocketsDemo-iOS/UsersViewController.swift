//
//  ViewController.swift
//  WebsocketsDemo-iOS
//
//  Created by Alyssa Torres on 3/1/17.
//  Copyright © 2017 Ourglass. All rights reserved.
//

import UIKit

class UsersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var userTable: UITableView!

    var nickname: String!
    
    var users = [[String: AnyObject]]()

    @IBAction func exitChat(_ sender: Any) {
        SocketIOManager.sharedInstance.exitChatWithNickname(nickname: nickname)
        self.nickname = nil
        self.users.removeAll()
        self.userTable.isHidden = true
        self.askForNickname()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userTable.delegate = self
        self.userTable.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if nickname == nil {
            self.askForNickname()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func askForNickname() {
        let alertController = UIAlertController(title: "", message: "Please enter a nickname.", preferredStyle: .alert)
        
        alertController.addTextField(configurationHandler: nil)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
            let textfield = alertController.textFields![0]
            
            if textfield.text?.characters.count == 0 {
                self.askForNickname()
                
            } else {
                self.nickname = textfield.text!
                
                SocketIOManager.sharedInstance.connectToServerWithNickname(nickname: self.nickname)
                SocketIOManager.sharedInstance.getUserList(handler: { (userList) -> Void in
                    DispatchQueue.main.async(execute: {
                        self.users = userList
                        self.userTable.reloadData()
                        self.userTable.isHidden = false
                    })
                })
            }
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: UITableView Delegate and DataSource methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserCell
        
        cell.isUserInteractionEnabled = true
        
        cell.textLabel?.text = users[indexPath.row]["nickname"] as? String
        
        let isConnected = users[indexPath.row]["isConnected"] as! Bool
        cell.detailTextLabel?.text = isConnected ? "online" : "offline"
        cell.detailTextLabel?.textColor = isConnected ? UIColor.green : UIColor.red
        
        return cell
    }

}

