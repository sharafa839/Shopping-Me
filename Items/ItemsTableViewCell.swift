//
//  ItemsTableViewCell.swift
//  Shopping
//
//  Created by ahmed on 30/01/2021.
//  Copyright © 2021 ahmed. All rights reserved.
//

import UIKit

class ItemsTableViewCell: UITableViewCell {

    @IBOutlet weak var ItemPrice: UILabel!
    @IBOutlet weak var ItemDescroption: UILabel!
    @IBOutlet weak var ItemName: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func generateCell(item:Items){
        ItemName.text = item.name
        ItemDescroption.text = item.description
        ItemPrice.text = CurrencyConverter(item.price)
        ItemPrice.adjustsFontSizeToFitWidth = true
        if item.imageLinks != nil && item.imageLinks.count > 0 {
            dwonloadImage(imageUrls: [item.imageLinks.first!]) { (images) in
                self.itemImage.image = images.first
            }
        }
        
    }
    
   
}
func dwonloadImage(imageUrls:[String], compeletion:@escaping(_ images:[UIImage])->Void){
       
       var imageArray:[UIImage] = []
       var CounterOfImage = 0
       for link in imageUrls {
           let url = NSURL(string: link)
           let downloadQueue = DispatchQueue(label: "DownloadImages")
           downloadQueue.async {
               CounterOfImage += 1
               let data = NSData(contentsOf: url! as URL)
               if data != nil {
                   imageArray.append(UIImage(data: data! as Data)!)
                   if CounterOfImage == imageArray.count {
                       DispatchQueue.main.async {
                           compeletion(imageArray)
                       }
                   }
               }else{
                   print("couldn't Download Image")
                   compeletion(imageArray)
               }
               
           }
           
       }
       
   }
