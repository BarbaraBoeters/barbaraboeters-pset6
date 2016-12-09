//
//  ViewController.swift
//  barbaraboeters-pset6
//
//  Created by Barbara Boeters on 06-12-16.
//  Copyright © 2016 Barbara Boeters. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var recipes: Array<Recipe> = Array<Recipe>()
//    let recipes = ["Curry", "Lasagna", "Pasta"]

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputSearch: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var searchInput = "Chicken".replacingOccurrences(of: " ", with: "+")
        print(searchInput)
        //        http://food2fork.com/api/search?key={API_KEY}&q=shredded%20chicken
        let API_KEY = "58e05dcdb2c818e392f22e629832ad1d"
        let myUrl = URL(string: "http://food2fork.com/api/search?key=\(API_KEY)&q=\(searchInput)")
        var request = URLRequest(url: myUrl!)
        print(request)
        API(request: request)
    }
    
    func API(request: URLRequest) {
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            // Guards execute when the condition is NOT met
            guard let data = data, error == nil else {
                
                // Error handling: what does the user expect when this fails?
                print("error getting the data ")
                return
            }
            do {
                // Convert data to JSON. You will need to do-catch code for this part
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
//                    print(json)
                    
                    // Get access to the main thread and the interface elements:
                    DispatchQueue.main.async {
                        let recipes = json.value(forKey: "recipes") as! Array<NSDictionary>
                        print(json)
                        for recipe in recipes {
                            let newRecipe = Recipe(title: recipe.value(forKey: "title") as! String, image: recipe.value(forKey: "image_url") as! String, url: recipe.value(forKey: "f2f_url") as! String)
                            // print(recipe.value(forKey: "title"))
                            // print(recipe.value(forKey: "image_url"))
                            self.recipes.append(newRecipe)
                        }
                        print(self.recipes)
                        self.tableView.reloadData()
                        
//                        let recipe = recipes[0] as! NSDictionary
                        
                        
//                        let recipe = Recipe(title: json.allKeys)
//                        self.recipes.append(recipe)
//                        print(recipe)
                    }
                } else {
                    print("couldn't convert data to JSON")
                    return
                }
            } catch {
                // Error handling what does the user expect when this fails?
                print("Error trying to convert data to JSON")
            }
        }).resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        cell.name.text = recipes[indexPath.row].title
        cell.getPoster(url: recipes[indexPath.row].image)
        
        // if let image = UIImage()
        return cell
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showDetail" {
//            if let indexPath = self.tableView.indexPathForSelectedRow {
//                let task = ToDoManager.sharedInstance.readList(index: indexPath.row)
//                // print(task)
//                //(segue.destination as! DetailViewController).detailItem = task
//                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
//                controller.detailItem = task
//            }
//        }
//    }
    
}

