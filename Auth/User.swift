//
//  User.swift
//  Shopping
//
//  Created by ahmed on 14/02/2021.
//  Copyright © 2021 ahmed. All rights reserved.
//

import Foundation
import FirebaseAuth
class  User {
    let  objectID : String
    var email:String
    var firstName:String
    var lastName:String
    var _fullName:String
    var purchsedItems :[String]
    var fullAdress:String?
    var onBoard : Bool
    init(objectID:String,email:String,firstName:String,lastName:String) {
        self.objectID = objectID
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        _fullName = firstName + " " + lastName
        fullAdress = ""
        purchsedItems = []
        onBoard = false
    }
    init(_dictionary:NSDictionary) {
        objectID = _dictionary[K.OBJECTID] as! String
        if let mail = _dictionary[K.kEmail] {
            email = mail as! String
        }else{
            email = " "
        }
        if let fName = _dictionary[K.kFirstName] {
            firstName = fName as! String
        }else{
            firstName = " "
        }
        if let lName = _dictionary[K.kLastName] {
            lastName = lName as! String
        }else{
            lastName = " "
        }
        _fullName = firstName + " " + lastName
        
        if let fAdress = _dictionary[K.kFullAdress] {
            fullAdress = fAdress as? String
        }else{
            fullAdress = " "
        }
        if let purchedItems = _dictionary[K.kPurchedItems] {
            purchsedItems = purchedItems as! [String]
        }else{
            purchsedItems = []
        }
        if let onboard = _dictionary[K.kOnBoard] {
            onBoard = onboard as! Bool
        }else{
            onBoard = false
        }
        
    }
    class func currentId()->String {
        return Auth.auth().currentUser!.uid
    }
    class func currentUser()->User? {
        
        if Auth.auth().currentUser != nil {
            if let dictionaryOfUserInfo = UserDefaults.standard.object(forKey: K.kCurrentUser){
                return User.init(_dictionary: dictionaryOfUserInfo as! NSDictionary )
            }
        }
        return nil
    }
    
    
    //MARK: - login function
    class func loginUserWith(email:String,password:String,compeletion:@escaping(_ error:Error?, _ isEmailVerified:Bool)->Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (AuthDataResult, Error) in
            if Error == nil {
                if (AuthDataResult?.user.isEmailVerified)!{
                    downloadUserFromFirestore(userId: (AuthDataResult?.user.uid)!, email: email)
                    compeletion(Error,true)
                    
                }
            }else{
                print("Email is not verfied")
                compeletion(Error!,false)
            }
        }
        
    }
    class func registerUserWith(email:String,password:String,compeletion:@escaping(_ error:Error?)->Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (AuthDataResult, error) in
            
            compeletion(error)
            if error == nil {
                AuthDataResult?.user.sendEmailVerification(completion: { (error) in
                    if error != nil{
                        print("error while sending email verfication \(String(describing: error?.localizedDescription))")
                    }else{
                        downloadUserFromFirestore(userId: (AuthDataResult?.user.uid)!, email: email)
                        compeletion(nil)
                    }
                    
                })
            } 
        }
    }
    
    
    
    //MARK: - Reseend Link To Reassign Password
    class func resetPassword(email:String,compeletion:@escaping (_ error:Error?)->Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error != nil{
                
                
                print("error in reset password \(error!)")
                compeletion(error)
            }
            else{
                print("No error")
                compeletion(nil)
            }
        }
    }
    
    //MARK: - Reseend Link To Resend email verfication
    class func resendEmailVerfication(email:String,compeletion:@escaping(_ error:Error?)->Void) {
        Auth.auth().currentUser?.reload(completion: { (error) in
            Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                if error != nil{
                    print("error in resend email verfication \(String(describing: error))")
                    compeletion(error)
                }else{
                    compeletion(nil)
                }
            })
        })
    }
    
}


//MARK: - Helper function

func saveUserToFireBase(user:User){
    
    FirebaseReference(.User).document(user.objectID).setData(userDictonary(user: user) as! [String : Any]) { (error) in
        if error != nil {
            print("Error in saving user\(error!.localizedDescription)")
        }
    }
}

func userDictonary(user:User)->NSDictionary{
    return NSDictionary(objects: [user.objectID,user.firstName,user.lastName,user._fullName,user.email,user.fullAdress ?? " ",user.purchsedItems,user.onBoard], forKeys: [K.OBJECTID  as NSCopying,K.kFirstName as NSCopying,K.kLastName as NSCopying,K.kFullName as NSCopying,K.kEmail as NSCopying ,K.kFullAdress as NSCopying,K.kPurchedItems as NSCopying,K.kOnBoard as NSCopying])
}
func saveUserLocally(dictionaryOfUser:NSDictionary){
    UserDefaults.standard.set(dictionaryOfUser, forKey: K.kCurrentUser)
    UserDefaults.standard.synchronize()
}

//MARK: - LoadingUserFromFireStotr

func downloadUserFromFirestore(userId:String,email:String)  {
    FirebaseReference(.User).document(userId).getDocument { (snapshot, error) in
        guard let snapshot = snapshot else{return}
        if snapshot.exists{
            // if user exist save him
            saveUserLocally(dictionaryOfUser: snapshot.data()! as NSDictionary)
        }else{
            let user = User(objectID: userId, email: email, firstName: "", lastName: "")
            saveUserLocally(dictionaryOfUser: userDictonary(user: user))
            saveUserToFireBase(user: user)
        }
    }
    
}


func updatingUser(_ withValues:[String:Any],completion: @escaping(_ error:Error?)->Void){
    print("UPdata")
    
    if let dictionary = UserDefaults.standard.object(forKey: K.kCurrentUser){
        let userObject = (dictionary as! NSDictionary).mutableCopy() as! NSMutableDictionary
        userObject.setValuesForKeys(withValues)
        FirebaseReference(.User).document(User.currentId()).updateData(withValues) { (error) in
            completion(error)
            if error == nil {
                saveUserLocally(dictionaryOfUser: userObject)
            }
        }
    }
}

