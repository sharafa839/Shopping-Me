//
//  FirebaseCollectionReference.swift
//  Shopping
//
//  Created by ahmed on 21/01/2021.
//  Copyright © 2021 ahmed. All rights reserved.
//

import Foundation
import FirebaseFirestore

public enum FCollectionReference :String {
    case User
    case Category
    case Basket
    case Items
}
 public func FirebaseReference(_ collectionReference:FCollectionReference) -> CollectionReference {
    
    
    return Firestore.firestore().collection(collectionReference.rawValue)
}
