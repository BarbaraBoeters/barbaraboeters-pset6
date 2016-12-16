//
//  ViewController.swift
//  barbaraboeters-pset6
//
//  Main viewcontroller wherein you can search for recipes by ingredients.
//  using an API request. Also you can access the groceries list from this
//  viewcontroller. When you select the recipe it goes to the
//  ShowDetailsViewController where you can see the title and part of the
//  website in a webview. 
//
//  Created by Barbara Boeters on 06-12-16.
//  Copyright © 2016 Barbara Boeters. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Constants
    let detailSegueIdentifier = "showDetails"
    let listToUsers = "ListToUsers"

    // Properties
    var recipes: Array<Recipe> = Array<Recipe>()
    var user: User!
    let usersRef = FIRDatabase.database().reference(withPath: "online")
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputSearch: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Authentication observer to the Firebase auth object, that in turn assigns the user property when a user successfully signs in
        // Call onDisconnectRemoveValue() on currentUserRef. This removes the value at the reference’s location after the connection to Firebase closes, for instance when a user quits your app. This is perfect for monitoring users who have gone offline.
        
        tableView.allowsMultipleSelectionDuringEditing = false
        
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
            let currentUserRef = self.usersRef.child(self.user.uid)
            currentUserRef.setValue(self.user.email)
            currentUserRef.onDisconnectRemoveValue()
        }
    }
    
    @IBAction func searchButton(_ sender: Any) {
        if inputSearch.text != "" {
            // Emptying the datasource and reloading the tableview
            recipes.removeAll()
            self.tableView.reloadData()
            // Use the userinput for calling the API
            var searchFood = inputSearch.text!.replacingOccurrences(of: " ", with: "+")
            let API_KEY = "58e05dcdb2c818e392f22e629832ad1d"
            let myUrl = URL(string: "http://food2fork.com/api/search?key=\(API_KEY)&q=\(searchFood)")
            var request = URLRequest(url: myUrl!)
            API(request: request)
        }
    }
    
    func API(request: URLRequest) {
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            // Guards execute when the condition is NOT met
            guard let data = data, error == nil else {
                print("error getting the data ")
                return
            }
            do {
                // Convert data to JSON
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print(json)
                    // Get access to the main thread and the interface elements:
                    DispatchQueue.main.async {
                        let recipes = json.value(forKey: "recipes") as! Array<NSDictionary>
                        for recipe in recipes {
                            let newRecipe = Recipe(title: recipe.value(forKey: "title") as! String, image: recipe.value(forKey: "image_url") as! String, url: recipe.value(forKey: "f2f_url") as! String)
                            self.recipes.append(newRecipe)
                        }
                        print(self.recipes)
                        self.tableView.reloadData()
                    }
                } else {
                    print("couldn't convert data to JSON")
                    return
                }
            } catch {
                print("Error trying to convert data to JSON")
            }
        }).resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        cell.name.text = recipes[indexPath.row].title
        cell.getPoster(url: recipes[indexPath.row].image)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == detailSegueIdentifier {
            if let indexRecipe = tableView.indexPathForSelectedRow?.row {
                let destination = segue.destination as? ShowDetailsViewController
                destination?.nameRecipe = self.recipes[indexRecipe].title
                destination?.urlRecipe = self.recipes[indexRecipe].url
            }
        }
    }
    
    // Logging out function which does not operate yet.
    @IBAction func logOutButton(_ sender: Any) {
        do {
            try! FIRAuth.auth()!.signOut()
            dismiss(animated: true, completion: nil)
        } catch {
            print ("Error signing out")
        }
    }
}

