//
//  Recipe.swift
//  barbaraboeters-pset6
//
//  An object that saves the title, image and url from the API data
//
//  Created by Barbara Boeters on 09-12-16.
//  Copyright © 2016 Barbara Boeters. All rights reserved.
//

import Foundation

class Recipe {
    let title: String
    let image: String
    let url: String
    
    init (title: String, image: String, url: String) {
        self.title = title
        self.image = image
        self.url = url
    }
}
