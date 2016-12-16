//
//  CustomCell.swift
//  barbaraboeters-pset6
//
//  TableViewCell in which you edit the cell from ViewController
//  It shows the title of the recipe and an image. 
//
//  Created by Barbara Boeters on 09-12-16.
//  Copyright © 2016 Barbara Boeters. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    // MARK: Outlets
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var viewImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func getPoster(url: String) {
        print(url)
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                self.viewImage.image = UIImage(data: data)
            }
        }).resume()
    }
}
