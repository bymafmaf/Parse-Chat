//
//  LoginVC.swift
//  ParseChat
//
//  Created by monus on 2/22/17.
//  Copyright © 2017 Mufi. All rights reserved.
//

import UIKit
import Parse

class LoginVC: UIViewController {
    var user: PFUser?
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBAction func onLoginButton(_ sender: Any) {
        PFUser.logInWithUsername(inBackground: emailText.text!, password: passwordText.text!) { (user: PFUser?, error: Error?) in
            if let error = error {
                let errorString = error.localizedDescription 
                // Show the errorString somewhere and let the user try again.
                let alertController = UIAlertController(title: "Error", message: errorString, preferredStyle: .alert)
                alertController.show(self, sender: nil)
            } else {
                self.user = user!
                
                self.performSegue(withIdentifier: "mainNavVCSegue", sender: self)
            }
        }
    }
    @IBAction func onSignupButton(_ sender: Any) {
        user = PFUser()
        user!.username = emailText.text!
        user!.password = passwordText.text!
        user!.email = emailText.text!
        
        user!.signUpInBackground { (succeded: Bool, error: Error?) in
            if let error = error {
                let errorString = error.localizedDescription 
                // Show the errorString somewhere and let the user try again.
                let alertController = UIAlertController(title: "Error", message: errorString, preferredStyle: .alert)
                alertController.show(self, sender: nil)
            } else {
                // Hooray! Let them use the app now.
                
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
