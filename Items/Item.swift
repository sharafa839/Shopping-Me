//
//  Item.swift
//  Shopping
//
//  Created by ahmed on 23/01/2021.
//  Copyright © 2021 ahmed. All rights reserved.
//

import Foundation
class Items {
    var name:String!
    var id:String!
    var description:String!
    var imageLinks : [String]!
    var price :Double!
    var categoryId:String!
   
     
    init() {
    }
    init(_dictionary:NSDictionary) {
        name = _dictionary[K.name] as? String
        categoryId = _dictionary[K.kCategoryId] as? String
        id = _dictionary[K.OBJECTID]as?String
        description = _dictionary[K.kDescription] as? String
        imageLinks = _dictionary[K.KimageLinks] as? [String]
        price = _dictionary[K.Kpric] as? Double
    }
}
    func saveItemsToFirebase(items:Items){
        
        
        FirebaseReference(.Items).document(items.id).setData(itemsDictionaryFrom(items: items) as! [String : Any])

    }
    
    
func itemsDictionaryFrom(items:Items) -> NSDictionary {
        return NSDictionary(objects: [items.name,items.id,items.categoryId,items.description,items.price,items.imageLinks], forKeys: [K.name as NSCopying,K.OBJECTID as NSCopying,K.kCategoryId as NSCopying,K.kDescription as NSCopying,K.Kpric as NSCopying,K.KimageLinks as NSCopying])
    }

// To downloadItemFrom FireBase


func downloadItemsFromFireBase(categoryId:String , completion:@escaping(_ itemArray : [Items]) -> Void) {
    
    var itemArray:[Items] = []
    FirebaseReference(.Items).whereField(K.kCategoryId, isEqualTo: categoryId).addSnapshotListener { (snapshot, Error) in
        guard let snapshot = snapshot else {
            completion(itemArray)
            return
        }
        if !snapshot.isEmpty{
            for itemdict in snapshot.documents {
                itemArray.append(Items(_dictionary: itemdict.data() as NSDictionary))
            }
        }
        completion(itemArray)
    }
}

