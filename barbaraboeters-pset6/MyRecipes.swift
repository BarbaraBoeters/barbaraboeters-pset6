//
//  MyRecipes.swift
//  barbaraboeters-pset6
//
//  Created by Barbara Boeters on 13-12-16.
//  Copyright © 2016 Barbara Boeters. All rights reserved.
//

import Foundation

class MyRecipes : NSObject, NSCoding{
    
    // Recipes dictionary variable
    var name: String?
    var html_url: String?
    
    init(json: NSDictionary) { // Dictionary object
        self.name = json["name"] as? String
        self.html_url = json["html_url"] as? String // Location of the JSON file
    }
    
    required init(coder aDecoder: NSCoder) {
        
        self.name = aDecoder.decodeObject(forKey: "name") as? String;
        self.html_url = aDecoder.decodeObject(forKey: "html") as? String;
    }
    
    func encode(with aCoder: NSCoder) {
        //encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name");
        aCoder.encode(self.html_url, forKey: "html");
    }
}


