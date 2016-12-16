//
//  CustomGroceriesCell.swift
//  barbaraboeters-pset6
//
//  TableViewCell in which you edit the cell from MyRecipesViewController.
//  It shows the name of the item and the user who added it.
//
//  Created by Barbara Boeters on 13-12-16.
//  Copyright © 2016 Barbara Boeters. All rights reserved.
//

import UIKit

class CustomGroceriesCell: UITableViewCell {

    // MARK: Outlets
    @IBOutlet weak var newItem: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
