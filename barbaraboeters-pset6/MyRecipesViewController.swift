//
//  MyRecipesViewController.swift
//  barbaraboeters-pset6
//
//  A list in which you can add groceries. It will display the item and the user who added it 
//  This is saved into Firebase and can be edited by multiple users.
//
//  Created by Barbara Boeters on 13-12-16.
//  Copyright © 2016 Barbara Boeters. All rights reserved.
//

import UIKit
import Firebase

class MyRecipesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Properties
    var items: [GroceryItem] = []
    var user: User!
    let ref = FIRDatabase.database().reference(withPath: "grocery-items")
    let usersRef = FIRDatabase.database().reference(withPath: "online")

    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
            let currentUserRef = self.usersRef.child(self.user.uid)
            currentUserRef.setValue(self.user.email)
            currentUserRef.onDisconnectRemoveValue()
        }
        
        ref.queryOrdered(byChild: "completed").observe(.value, with: { snapshot in
            var newItems: [GroceryItem] = []
            for item in snapshot.children {
                let groceryItem = GroceryItem(snapshot: item as! FIRDataSnapshot)
                newItems.append(groceryItem)
            }
            self.items = newItems
            self.tableView.reloadData()
        })
        
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
        }
    }
    
    // MARK: UITableView Delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomGroceriesCell
        let groceryItem = items[indexPath.row]
        cell.newItem?.text = groceryItem.name
        cell.userName?.text = groceryItem.addedByUser
        // cell.detailTextLabel?.text = groceryItem.addedByUser
        toggleCellCheckbox(cell, isCompleted: groceryItem.completed)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let groceryItem = items[indexPath.row]
            groceryItem.ref?.removeValue()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let groceryItem = items[indexPath.row]
        let toggledCompletion = !groceryItem.completed
        toggleCellCheckbox(cell, isCompleted: toggledCompletion)
        groceryItem.ref?.updateChildValues([
            "completed": toggledCompletion
            ])
    }
    
    /// Checking off items.
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
    
    // MARK: Actions
    @IBAction func addButtonDidTouch(_ sender: Any) {
        let alert = UIAlertController(title: "Grocery Item",
                                      message: "Add an Item",
                                      preferredStyle: .alert)
        
        // Using the current user’s data, create a new GroceryItem
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { _ in
                                        guard let textField = alert.textFields?.first,
                                            let text = textField.text else { return }
                                        let groceryItem = GroceryItem(name: text,
                                                                      addedByUser: self.user.email,
                                                                      completed: false)
                                        let groceryItemRef = self.ref.child(text.lowercased())
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
