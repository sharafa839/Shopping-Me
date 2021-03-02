//
//  ItemDetailsViewController.swift
//  Shopping
//
//  Created by ahmed on 01/02/2021.
//  Copyright © 2021 ahmed. All rights reserved.
//

import UIKit
import JGProgressHUD
class ItemDetailsViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var imgesCollectionView: UICollectionView!
    @IBOutlet weak var nameOfItem: UILabel!
    @IBOutlet weak var priceOfItem: UILabel!
    @IBOutlet weak var DescriptionOfItem: UITextView!
    // MARK: - Vars
    var itemSelected : Items!
    var Images : [UIImage] = []
    static var  arrayOfBasketItems : [String] = []
    let hud = JGProgressHUD(style: .dark)
    private let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 10)
    private let cellHeight:CGFloat = 196.0
    let itemsPerRow : CGFloat = 1
    private static var id = UUID().uuidString
    private var isCreated:Bool = true
    private let defaults = UserDefaults.standard
    private static var userID = UUID().uuidString
    private var huds = JGProgressHUD(style: .dark)

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDetails()
        downlaodPictures ()
     /*   if let saved = defaults.array(forKey: "BASKETARRAY") as? [String] {
            ItemDetailsViewController.arrayOfBasketItems = saved
        }
        if let BasketID = defaults.string(forKey: "BASKETID") {
            ItemDetailsViewController.id = BasketID
        }
        if let userID = defaults.string(forKey: "USERID"){
            ItemDetailsViewController.userID=userID
        }*/
        
    }
    
    
    func getDetails() {
        if itemSelected != nil{
            nameOfItem.text = itemSelected.name
            priceOfItem.text = CurrencyConverter(itemSelected.price)
            DescriptionOfItem.text = itemSelected.description
            
            
        }
    }
    func downlaodPictures () {
        if itemSelected != nil && itemSelected.imageLinks != nil {
            dwonloadImage(imageUrls: itemSelected.imageLinks) { (allimages) in
                if allimages.count > 0 {
                    self.Images = allimages
                    self.imgesCollectionView.reloadData()
                }
            }
        }
    }
    
    
    
    
    @IBAction func basketbuttonPressed(_ sender: UIBarButtonItem) {
        if User.currentUser() != nil{
            downloadBasketFromFireStore(User.currentId()) { (basket) in
                if basket == nil{
                    self.createNewBasket()
                }else{
                    basket?.itemId?.append(self.itemSelected.id)
                    self.updateingBasket(basket: basket!, withValues: [K.KItemId : basket!.itemId!])
                }
            }
        }else{
            showloginView()

        }
        
       
    }
    //MARK:- Helper Function
    
    func createNewBasket (){
        let newBasket = Basket()
        newBasket.id = UUID().uuidString
       // defaults.set(newBasket.id, forKey: "BASKETID")
        newBasket.itemId = [itemSelected.id]
        //ItemDetailsViewController.arrayOfBasketItems.append(itemSelected.id)
        //basketk.itemId = ItemDetailsViewController.arrayOfBasketItems
        //defaults.set(newBasket.itemId, forKey: "BASKETARRAY")
        newBasket.ownerId = User.currentId()
        //defaults.set(newBasket.ownerId, forKey: "USERID")
        saveBasketToFireStore(basket: newBasket)
        
        /*if isCreated {
         saveBasketToFireStore(basket: basketk)
         isCreated = false
         }else{
         
         updatingBasket(basketk, [K.KItemId :basketk.itemId as Any]) { (Eror) in
         
         }*/
    }
    
    private func updateingBasket(basket:Basket,withValues: [String:Any]){
        updatingBasket(basket, withValues) { (error) in
            if error != nil {
                self.huds.textLabel.text = "ERROR:\(error!.localizedDescription)"
                self.huds.indicatorView = JGProgressHUDErrorIndicatorView()
                self.huds.show(in: self.view)
                self.huds.dismiss(afterDelay: 2.0)
            }else{
                self.huds.textLabel.text = "Added To Basket"
                self.huds.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.huds.show(in: self.view)
                self.huds.dismiss(afterDelay: 2.0)
            }
        }
    }
    private func showloginView(){
        let itemVc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "login")
        self.present(itemVc, animated: true, completion: nil)
}

}



//MARK: - basket






extension ItemDetailsViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Images.count == 0 ? 1 : Images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "cells", for: indexPath)as! ImageCollectionViewCell
        if Images.count > 0 {
            cell.setUpImagesView(ItemImage: Images[indexPath.row])
        }
        
        
        return cell
    }
    
    
}

extension ItemDetailsViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let avilableSpace = collectionView.frame.width - sectionInsets.left
        
        return CGSize(width: avilableSpace, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
