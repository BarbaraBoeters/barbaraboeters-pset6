//
//  LoggingInViewController.swift
//  barbaraboeters-pset6
//
//  The very first viewcontroller in charge of logging in or signing up
//  Use of Firebase. 
//
//  Created by Barbara Boeters on 14-12-16.
//  Copyright © 2016 Barbara Boeters. All rights reserved.
//

import UIKit
import Firebase

class LoggingInViewController: UIViewController {

    // Constants
    let loginToList = "LoginToList"
    
    // Outlets
    @IBOutlet weak var inputEmail: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    
    // Actions
    @IBAction func logInButton(_ sender: Any) {
        
        if inputEmail.text != "" && inputPassword.text != "" {
            FIRAuth.auth()!.signIn(withEmail: inputEmail.text!, password: inputPassword.text!)
        } else {
            let alert = UIAlertController(title: "Oops!",
                                          message: "You didn't enter a valid e-mail and/or password",
                                          preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok!", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        // FIRAuth.auth()!.signIn(withEmail: inputEmail.text!, password: inputPassword.text!)

    }
    
    @IBAction func signUpButton(_ sender: Any) {
        let alert = UIAlertController(title: "Register",
                                      message: "Register",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { action in
                                        // 1
                                        let emailField = alert.textFields![0]
                                        let passwordField = alert.textFields![1]
                                        
                                        // 2
                                        FIRAuth.auth()!.createUser(withEmail: emailField.text!,
                                                                   password: passwordField.text!) { user, error in
                                                                    if error == nil {
                                                                        // 3
                                                                        FIRAuth.auth()!.signIn(withEmail: self.inputEmail.text!,
                                                                                               password: self.inputPassword.text!)
                                                                    }
                                        }
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField { textEmail in
            textEmail.placeholder = "Enter your email"
        }
        
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}
// Uitleg
extension LoggingInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == inputEmail {
            inputPassword.becomeFirstResponder()
        }
        if textField == inputPassword {
            textField.resignFirstResponder()
        }
        return true
    }
    
    // Create an authentication observer using addStateDidChangeListener(_:).Test the value of user. Upon successful user authentication, user is populated with the user’s information. If authentication fails, the variable is nil. On successful authentication, perform the segue. Pass nil as the sender.
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            // 2
            if user != nil {
                // 3
                self.performSegue(withIdentifier: self.loginToList, sender: nil)
            }
        }
        inputEmail.text = ""
        inputPassword.text = ""
    }
}
