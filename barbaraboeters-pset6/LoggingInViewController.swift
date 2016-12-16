//
//  LoggingInViewController.swift
//  barbaraboeters-pset6
//
//  The first viewcontroller in charge of logging in or signing up.
//  Use of state restoration which saves the textfield where the e-mail is written in.
//  It also uses Userdefaults to save the e-mailaddress which was used the last time.
//  Saves the userdata in Firebase.
//  Use of alerts when the user didn't enter an email/password.
//
//  Created by Barbara Boeters on 14-12-16.
//  Copyright © 2016 Barbara Boeters. All rights reserved.
//

import UIKit
import Firebase

class LoggingInViewController: UIViewController {

    // Mark: Properties
    let loginToList = "LoginToList"
    
    // Mark: Outlets
    @IBOutlet weak var inputEmail: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    @IBOutlet weak var lastUser: UILabel!
    @IBOutlet weak var usedLabel: UILabel!
    
    // Mark: Actions
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
        UserDefaults.standard.set(inputEmail.text!, forKey: "email")
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        let alert = UIAlertController(title: "Register",
                                      message: "Register",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
           style: .default) { action in
            let emailField = alert.textFields![0]
            let passwordField = alert.textFields![1]
            FIRAuth.auth()!.createUser(withEmail: emailField.text!,
               password: passwordField.text!) { user, error in
                if error == nil {
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
    
    // MARK: State restoration
    
    override func encodeRestorableState(with coder: NSCoder) {
        if let email = inputEmail.text {
            coder.encode(email, forKey: "email")
        }
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        inputEmail.text = coder.decodeObject(forKey: "email") as! String?
        super.decodeRestorableState(with: coder)
    }
}

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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create an authentication observer using addStateDidChangeListener(_:).
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            if user != nil {
                self.performSegue(withIdentifier: self.loginToList, sender: nil)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        inputPassword.text = ""
        
        // Using Userdefault to save data on the phone itself.
        if let email = UserDefaults.standard.string(forKey: "email") {
            usedLabel.text = "Last used by:"
            lastUser.text = email
        } else {
            usedLabel.text = ""
            lastUser.text = ""
        }
    }
}
