//
//  ShowDetailsViewController.swift
//  barbaraboeters-pset6
//
//  Created by Barbara Boeters on 12-12-16.
//  Copyright © 2016 Barbara Boeters. All rights reserved.
//

import UIKit

class ShowDetailsViewController: UIViewController {

    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var webView: UIWebView!
    
    var nameRecipe = String()
    var urlRecipe = "http://picky-palate.com/2012/09/20/pesto-ranch-crock-pot-chicken-thighs/"
    // var urlRecipe = String()
    
    override func viewWillAppear(_ animated: Bool) {
        self.recipeName.text = nameRecipe
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let url = NSURL (string: urlRecipe)
        let requestObj = NSURLRequest(url: url! as URL)
        webView.loadRequest(requestObj as URLRequest);
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
