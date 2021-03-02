//
//  CategoryCollectionViewCell.swift
//  Shopping
//
//  Created by ahmed on 21/01/2021.
//  Copyright © 2021 ahmed. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    func  generateCell(category:Category) {
        nameLabel.text = category.name
        imageView.image = category.image
    }
}
