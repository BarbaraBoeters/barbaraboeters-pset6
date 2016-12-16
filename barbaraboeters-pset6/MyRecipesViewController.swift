//
//  MyRecipesViewController.swift
//  barbaraboeters-pset6
//
//  A list in which you can add groceries. This is saved into Firebase and can be
//  edited by multiple users. This is a handy feature for housemates or couples
//  who want to share a list in which they can add groceries even if they are not
//  in the same place. 
//
//  Created by Barbara Boeters on 13-12-16.
//  Copyright © 2016 Barbara Boeters. All rights reserved.
//

import UIKit
import Firebase

class MyRecipesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Properties
    var items: [GroceryItem] = []
    var user: User!
    
    // Constants
    let ref = FIRDatabase.database().reference(withPath: "grocery-items")
    let usersRef = FIRDatabase.database().reference(withPath: "online")

    // Outlets
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // UITLEG
        tableView.allowsMultipleSelectionDuringEditing = false

        // UITLEG
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
            // 1
            let currentUserRef = self.usersRef.child(self.user.uid)
            // 2
            currentUserRef.setValue(self.user.email)
            // 3
            currentUserRef.onDisconnectRemoveValue()
        }
        
        // Tap on a row to toggle its completion status. The completed items magically move to the bottom of the list.
        ref.queryOrdered(byChild: "completed").observe(.value, with: { snapshot in
            var newItems: [GroceryItem] = []
            
            for item in snapshot.children {
                let groceryItem = GroceryItem(snapshot: item as! FIRDataSnapshot)
                newItems.append(groceryItem)
            }
            
            self.items = newItems
            self.tableView.reloadData()
        })
        
        // Attaching an authentication observer to the Firebase auth object, that in turn assigns the user property when a user successfully signs in.
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
        }
    }
    
    // Delegate methods
    
    // Returns the number of rows to populate the tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    // Populates the cells with the item,
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomGroceriesCell
        let groceryItem = items[indexPath.row]
        cell.newItem?.text = groceryItem.name
        cell.userName?.text = groceryItem.addedByUser
        // cell.detailTextLabel?.text = groceryItem.addedByUser
        toggleCellCheckbox(cell, isCompleted: groceryItem.completed)
        return cell
    }
    
    // UITLEG
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    // Removing items from the local array and in Firebase
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let groceryItem = items[indexPath.row]
            groceryItem.ref?.removeValue()
        }
    }
    
    // Checking off items
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        // 2
        let groceryItem = items[indexPath.row]
        // 3
        let toggledCompletion = !groceryItem.completed
        // 4
        toggleCellCheckbox(cell, isCompleted: toggledCompletion)
        // 5
        groceryItem.ref?.updateChildValues([
            "completed": toggledCompletion
            ])
    }
    
    // Checking off items
    func toggleCellCheckbox(_ cell: UITableViewCell, isCompleted: Bool) {
        if !isCompleted {
            cell.accessoryType = .none
            cell.textLabel?.textColor = UIColor.black
            cell.detailTextLabel?.textColor = UIColor.black
        } else {
            cell.accessoryType = .checkmark
            cell.textLabel?.textColor = UIColor.gray
            cell.detailTextLabel?.textColor = UIColor.gray
        }
    }
    
    // UITLEG
    @IBAction func addButtonDidTouch(_ sender: Any) {
        let alert = UIAlertController(title: "Grocery Item",
                                      message: "Add an Item",
                                      preferredStyle: .alert)
        
        // Using the current user’s data, create a new GroceryItem
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { _ in
                                        // 1
                                        guard let textField = alert.textFields?.first,
                                            let text = textField.text else { return }
                                        
                                        // 2
                                        let groceryItem = GroceryItem(name: text,
                                                                      addedByUser: self.user.email,
                                                                      completed: false)
                                        // 3
                                        let groceryItemRef = self.ref.child(text.lowercased())
                                        
                                        // 4
                                        groceryItemRef.setValue(groceryItem.toAnyObject())
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}
