//
//  StripeClient.swift
//  Shopping
//
//  Created by ahmed on 18/02/2021.
//  Copyright © 2021 ahmed. All rights reserved.
//

import Foundation
import Stripe
import Alamofire
class StripeClients {
    static let sharedClient = StripeClients()
    var baseUrlString:String? = nil
    var baseUrl:URL{
        if let urlString = self.baseUrlString , let url = URL(string: urlString){
            return url
        }else{
            fatalError()
        }
    }
    
    func createAndConfirmPayment(_ token:STPToken,amount:Int,Compeletion:@ escaping(_ error:Error?)->Void)  {
     
        let url = self.baseUrl.appendingPathComponent("charge")
       
        let parms:[String:Any]=["token":token.tokenId,"amount":amount,"currency":Constant.defaultCurrency,"description":Constant.defaultDescribtion]
        
        Alamofire.request(url, method: .post, parameters: parms).validate(statusCode: 200..<300).responseData { (response) in
            print(url)
            switch response.result {
            case .success(_):
                print("Payment Successful")
                Compeletion(nil)
            case .failure(let error):
                print(error.localizedDescription ," fail in payment")
                Compeletion(error)
            }
        }
    }
}
