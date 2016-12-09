//
//  Recipe.swift
//  barbaraboeters-pset6
//
//  Created by Barbara Boeters on 09-12-16.
//  Copyright © 2016 Barbara Boeters. All rights reserved.
//

import Foundation

class Recipe {
    let title: String
    let image: String
    let url: String
    var completed = false
    
    init (title: String, image: String, url: String) {
        self.title = title
        self.image = image
        self.url = url
    }
}
