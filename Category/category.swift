//
//  category model cell.swift
//  Shopping
//
//  Created by ahmed on 21/01/2021.
//  Copyright © 2021 ahmed. All rights reserved.
//

import UIKit
import FirebaseFirestore
class Category {
    var name:String
    var imageName:String?
    var image:UIImage?
    var id :String
    init(_name:String,_imageName:String) {
        id  = ""
        name = _name
        imageName = _imageName
        image = UIImage(named: _imageName)
    }
    
    init(dictionary : NSDictionary) {
        id = dictionary[K.OBJECTID] as! String
        name = dictionary[K.name] as! String
        image = UIImage(named: dictionary[K.IMAGENAME] as? String ?? "")
    }
}

// MARK:- save category
func saveCategoryToFirebase(category:Category) {
    let uid = UUID().uuidString
    
    FirebaseReference(.Category).document(uid).setData(categoryDictionaryFrom(category: category) as! [String : Any] )
}

func categoryDictionaryFrom(category:Category) -> NSDictionary {
    
    
    return NSDictionary(objects: [category.name,category.id,category.imageName!], forKeys: [K.name as NSCopying, K.OBJECTID as NSCopying,K.IMAGENAME as NSCopying])
}

// MARK:- Download category
func downloadCategory(compeletion : @escaping (_ categoryArray:[Category])-> Void) {
    var categoryArray :[Category] = []
    FirebaseReference(.Category).getDocuments { (snapShot, Error) in
        guard let snapShot = snapShot else {
            compeletion(categoryArray)
            return
        }
        if !snapShot.isEmpty {
            for categoryDict in snapShot.documents {
                print("category is added \(categoryDict)")
                categoryArray.append(Category(dictionary: categoryDict.data() as NSDictionary))
            }
            compeletion(categoryArray)
        }
    }
}
func createCategorySet() {
    
    let womenClothing = Category(_name: "Women's Cloathing & Accessioories", _imageName: "womenCloth")
    let footWear = Category(_name: "Foot Wear", _imageName: "footWear")
    let electironics = Category(_name: "Electronics", _imageName: "electronics")
    let menClothing = Category(_name: "mens Clothing", _imageName: "menCloth")
    let health = Category(_name: "Health & Beauty", _imageName: "health")
    let baby = Category(_name: "Baby Stuff", _imageName: "baby")
    let home = Category(_name: "Home & Kitchen", _imageName: "home")
    let car = Category(_name: "Cars", _imageName: "car")
    let luaggage = Category(_name: "Luaggage & Bags", _imageName: "luaggage")
    let jewllery = Category(_name: "Jewllery", _imageName: "jewllery")
    let hoppy = Category(_name: "Hoppy,Sport,Travelling", _imageName: "hoppy")
    let pet = Category(_name: "Pet's Product", _imageName: "pet")
    let industry = Category(_name: "Industry & Bussiness", _imageName: "industry")
    let garden = Category(_name: "Garden supplies", _imageName: "garden")
    let camera = Category(_name: "camera optics", _imageName: "camera")
    let arrayOfCategories = [womenClothing,footWear,electironics,menClothing,home,health,baby,car,camera,luaggage,jewllery,hoppy,pet,industry,garden]
    for category in arrayOfCategories {
        saveCategoryToFirebase(category: category)
    }
  
}
