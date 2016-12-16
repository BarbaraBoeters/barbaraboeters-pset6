//
//  ViewController.swift
//  barbaraboeters-pset6
//
//  Main viewcontroller in which you can search for recipes by ingredients.
//  Use of Food2Fork API. You can access the groceries list from this
//  viewcontroller. When you select the recipe it segues to the
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
    
    // MARK: Properties
    let detailSegueIdentifier = "showDetails"
    let listToUsers = "ListToUsers"
    var recipes: Array<Recipe> = Array<Recipe>()
    var user: User!
    let usersRef = FIRDatabase.database().reference(withPath: "online")
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputSearch: UISearchBar!

    // MARK: Actions
    @IBAction func searchButton(_ sender: Any) {
        if inputSearch.text != "" {
            
            // Clear before adding new API data.
            recipes.removeAll()
            self.tableView.reloadData()
            
            let searchFood = inputSearch.text!.replacingOccurrences(of: " ", with: "+")
            let API_KEY = "58e05dcdb2c818e392f22e629832ad1d"
            let myUrl = URL(string: "http://food2fork.com/api/search?key=\(API_KEY)&q=\(searchFood)")
            let request = URLRequest(url: myUrl!)
            
            API(request: request)
        }
    }
    
    func API(request: URLRequest) {
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

            guard let data = data, error == nil else {
                self.presentAlert(message: "Error while getting the data")
                return
            }
            
            do {
                
                // Convert data to JSON.
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    
                    // Get access to the main thread and the interface elements:
                    DispatchQueue.main.async {
                        let recipes = json.value(forKey: "recipes") as! Array<NSDictionary>
                        
                        for recipe in recipes {
                            let newRecipe = Recipe(title: recipe.value(forKey: "title") as! String, image: recipe.value(forKey: "image_url") as! String, url: recipe.value(forKey: "f2f_url") as! String)
                            self.recipes.append(newRecipe)
                        }

                        self.tableView.reloadData()
                    }
                } else {
                    self.presentAlert(message: "Doesn't exist")
                    return
                }
            } catch {
                self.presentAlert(message: "Error trying to convert data to JSON")
            }
        }).resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UITableView Delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        cell.name.text = recipes[indexPath.row].title
        cell.getPoster(url: recipes[indexPath.row].image)
        return cell
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == detailSegueIdentifier {
            if let indexRecipe = tableView.indexPathForSelectedRow?.row {
                let destination = segue.destination as? ShowDetailsViewController
                destination?.nameRecipe = self.recipes[indexRecipe].title
                destination?.urlRecipe = self.recipes[indexRecipe].url
            }
        }
    }
    
    /// Logging out function which does not operate yet. Has been looked at by Julian & Bob.
    @IBAction func logOutButton(_ sender: Any) {
        do {
            try FIRAuth.auth()!.signOut()
            dismiss(animated: true, completion: nil)
        } catch {
            presentAlert(message: "Can't sign out")
        }
    }
    
    func presentAlert(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error",
                                          message: message,
                                          preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok!", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
            let currentUserRef = self.usersRef.child(self.user.uid)
            currentUserRef.setValue(self.user.email)
            currentUserRef.onDisconnectRemoveValue()
        }
    }
    
    // MARK: State restoration
    
    override func encodeRestorableState(with coder: NSCoder) {
        if let email = inputSearch.text {
            coder.encode(email, forKey: "email")
        }
        
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        inputSearch.text = coder.decodeObject(forKey: "email") as! String?
        super.decodeRestorableState(with: coder)
    }
}

