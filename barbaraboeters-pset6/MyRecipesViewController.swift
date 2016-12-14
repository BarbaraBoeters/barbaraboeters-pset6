//
//  MyRecipesViewController.swift
//  barbaraboeters-pset6
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
    let ref = FIRDatabase.database().reference(withPath: "grocery-items")
    let usersRef = FIRDatabase.database().reference(withPath: "online")

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsMultipleSelectionDuringEditing = false

        // Do any additional setup after loading the view.
        
        user = User(uid: "FakeId", email: "hungry@person.food")
        
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
            // 1
            let currentUserRef = self.usersRef.child(self.user.uid)
            // 2
            currentUserRef.setValue(self.user.email)
            // 3
            currentUserRef.onDisconnectRemoveValue()
        }
        
        // 1
        ref.observe(.value, with: { snapshot in
            // 2
            var newItems: [GroceryItem] = []
            
            // 3
            for item in snapshot.children {
                // 4
                let groceryItem = GroceryItem(snapshot: item as! FIRDataSnapshot)
                newItems.append(groceryItem)
            }
            
            // 5
            self.items = newItems
            self.tableView.reloadData()
        })
    }


//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomGroceriesCell
//        cell.newItem.text = items[indexPath.row].name
//        // cell.getPoster(url: myRecipes[indexPath.row].image)
//        return cell
        
        let groceryItem = items[indexPath.row]
        
        cell.newItem?.text = groceryItem.name
        cell.detailTextLabel?.text = groceryItem.addedByUser
        
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
    
    @IBAction func addButtonDidTouch(_ sender: Any) {
        let alert = UIAlertController(title: "Grocery Item",
                                      message: "Add an Item",
                                      preferredStyle: .alert)
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


