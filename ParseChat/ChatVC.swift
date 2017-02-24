//
//  ChatVC.swift
//  ParseChat
//
//  Created by monus on 2/23/17.
//  Copyright © 2017 Mufi. All rights reserved.
//

import UIKit
import Parse
class ChatVC: UIViewController, UITableViewDataSource {
    
    var messages: [Dictionary<String, String>] = []

    @IBOutlet weak var chatTable: UITableView!
    @IBOutlet weak var messageText: UITextField!
    
    @IBAction func sendButtonClicked(_ sender: UIButton) {
        var oneMessage = PFObject(className: "Message")
        oneMessage["text"] = messageText.text!
        oneMessage["user"] = PFUser.current()!
        oneMessage.saveInBackground {
            (success: Bool, error: Error?) -> Void in
            if (success) {
                // The object has been saved.
                print("saved!")
                
            } else {
                // There was a problem, check error.description
                print(error?.localizedDescription)
            }
        }
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
   
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatTable.dequeueReusableCell(withIdentifier: "ChatCellView") as! ChatCellView
        
        cell.textField.text = messages[indexPath.row]["text"]
        if let username = messages[indexPath.row]["username"] {
            cell.usernameText.text = username
        } else {
            cell.usernameText.isHidden = true
        }
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        chatTable.rowHeight = UITableViewAutomaticDimension
        chatTable.estimatedRowHeight = 100
        chatTable.dataSource = self
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: refreshMessages)
        
    }
    func refreshMessages(timer: Timer){
        let query = PFQuery(className:"Message")
        query.order(byDescending: "createdAt")
        query.includeKey("user")
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            if let problem = error {
                print(problem.localizedDescription)
            } else {
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                self.messages.removeAll()
                if let objects = objects {
                    for object in objects {
                        var fullMessage = Dictionary<String, String>()
                        if let aMessage = object["text"] as? String{
                            fullMessage["text"] = aMessage
                        }
                        if let itsUser = object["user"] as? PFUser {
                            if let emailExists = itsUser.email {
                                fullMessage["username"] = emailExists
                            }
                        }
                        self.messages.append(fullMessage)
                    }
                    DispatchQueue.main.async {
                        self.chatTable.reloadData()
                    }
                }
                
            }
            

        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
