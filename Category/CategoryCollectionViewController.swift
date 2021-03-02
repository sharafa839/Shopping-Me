//
//  CategoryCollectionViewController.swift
//  Shopping
//
//  Created by ahmed on 21/01/2021.
//  Copyright © 2021 ahmed. All rights reserved.
//

import UIKit


class CategoryCollectionViewController: UICollectionViewController {
    
    // MARK: - Variables
    var categoryArray : [Category] = []
    private let sectionInsets = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
    let itemsPerRow : CGFloat = 3

    override func viewDidLoad() {
        super.viewDidLoad()

        
                loadCateigories()


        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return categoryArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CategoryCollectionViewCell
        
        cell.generateCell(category: categoryArray[indexPath.row])
    
        // Configure the cell
    
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "categoryToItem", sender: categoryArray[indexPath.row])
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vcDestination = segue.destination  as? ItemsTableViewController{
            vcDestination.categorySelected = sender as? Category
        }
    }
    

    func loadCateigories () {
        downloadCategory { (allCategory) in
            print("tehre are \(allCategory.count) category")
            self.categoryArray.append(contentsOf: allCategory)
            self.collectionView.reloadData()
        }
    }

}
//MARK: - insets
extension CategoryCollectionViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padingSpace = sectionInsets.left * (itemsPerRow + 1)
        let avilableSpace = view.frame.width - padingSpace
        let widthPerItem = avilableSpace / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

