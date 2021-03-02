//
//  AlgoliaService.swift
//  Shopping
//
//  Created by ahmed on 21/02/2021.
//  Copyright © 2021 ahmed. All rights reserved.
//

import Foundation
import InstantSearchClient

class AlgoliaService {
     static let shared = AlgoliaService()
    
    let client = Client(appID: K.KAlgoliaAppId, apiKey: K.KAlgoliaAdminKey)
    
    let index = Client(appID: K.KAlgoliaAppId, apiKey: K.KAlgoliaAdminKey).index(withName: "item_name")
    
    private init(){
        
    }
}
