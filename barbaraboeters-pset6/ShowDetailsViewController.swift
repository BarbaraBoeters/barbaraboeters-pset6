//
//  ShowDetailsViewController.swift
//  barbaraboeters-pset6
//
//  Displaying the details when clicking on the recipy in the viewcontroller.
//  Showing the title of the recipe in a label and the
//  link to the website with the list of ingrediënts in a webview.
//
//  Created by Barbara Boeters on 12-12-16.
//  Copyright © 2016 Barbara Boeters. All rights reserved.
//

import UIKit

class ShowDetailsViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var webView: UIWebView!
    
    // MARK: Properties
    var nameRecipe = String()
    var urlRecipe = String()
    
    override func viewWillAppear(_ animated: Bool) {
        self.recipeName.text = nameRecipe
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Using the url from the API to populate the webview
        let url = NSURL (string: urlRecipe)
        let requestObj = NSURLRequest(url: url! as URL)
        webView.loadRequest(requestObj as URLRequest);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
