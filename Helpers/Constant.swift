//
//  Constant.Swift
//  Shopping
//
//  Created by ahmed on 21/01/2021.
//  Copyright © 2021 ahmed. All rights reserved.
//

import Foundation

// category
struct K{
    
     static let fileReference = "gs://shopping-ce6a2.appspot.com"
    static let KAlgoliaAppId = "Z8MIVQGW6L"
    static let KAlgoliaKey = "641ec6a75396f088148692b8c6132e2d"
    static let KAlgoliaAdminKey = "7503d21d6ef6cce32d991026673dfea2"
    
    
    
    
     static let name = "name"
     static let OBJECTID = "objectId"
     static let IMAGENAME = "imageName"

    //firebase
    public let KusersPath = "users"
    public let KcategoryPath = "categry"
    public let KbasketPath = "basket"
    public let KitemsPath = "items"
    
    //Items
    static let kCategoryId = "categoryId"
    static let kDescription = "description"
    static let Kpric = "price"
    static let KimageLinks = "imageLinks"
    //Basket
    static let kBasketId = "basketId"
    static let kOwnerId = "OnwerId"
    static let KItemId = "ItemId"
    //USer
    static let kEmail = "email"
    static let kFirstName = "FirstName"
    static let kLastName = "LastName"
    static let kFullName = "FullName"
    static let kCurrentUser = "CurrentUser"
    static let kFullAdress = "FullAdress"
    static let kOnBoard = "OnBoard"
    static let kPurchedItems = "PurchedItems"
    
    
}

enum Constant {
    static let  puplishableKey = "pk_test_51IMGanAgpBHJDaqt9BlaIDpdZaxlktaLqSCl5B2Nguhp15X1SNor6MUV8mwwKXtYGWd4VVa6q5X6rjkk5ZDdSetg00Rnw3j17I"
    static let  baseUrlString = "https://shopping22.herokuapp.com/"
    //"http://localhost:3000/"
    static let  defaultCurrency = "egp"
    static let  defaultDescribtion = "purchase from sharaf"
}
