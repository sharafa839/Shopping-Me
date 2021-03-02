
//
//  ImageCollectionViewCell.swift
//  Shopping
//
//  Created by ahmed on 01/02/2021.
//  Copyright © 2021 ahmed. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var Imagescell: UIImageView!
    
    func setUpImagesView(ItemImage:UIImage)  {
        Imagescell.image = ItemImage
    }
    
}
