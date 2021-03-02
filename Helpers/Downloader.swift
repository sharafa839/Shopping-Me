//
//  Downloader.swift
//  Shopping
//
//  Created by ahmed on 23/01/2021.
//  Copyright © 2021 ahmed. All rights reserved.
//

import Foundation
import FirebaseStorage

let storage =  Storage.storage()

func uploadImages(images:[UIImage?],itemId:String,compeletion: @escaping(_ linksOfImage:[String]) ->Void){

    if Reachability.hasConnection(){
        var uploadImagesCount = 0
        var imageLinkArray : [String] = []
        var nameSuffix = 0
        for image in images{
            let fileName = "ItemImages/" + itemId + "/" + "\(nameSuffix)" + ".jpg"
            let imageData = image!.jpegData(compressionQuality: 0.1)
            saveImage(imageData: imageData!, fileName: fileName) { (imageLink) in
                if imageLink != nil{
                    imageLinkArray.append(imageLink!)
                    uploadImagesCount += 1
                    if uploadImagesCount == images.count{
                        compeletion(imageLinkArray)
                    }
                }
            }
            nameSuffix += 1
        }
    }else{
        print("No Interenet Connection")
    }
    
    
    
    

}
func saveImage ( imageData:Data , fileName:String,compeletion: @escaping(_ imageLinks:String?)->Void){
    var task: StorageUploadTask!
    let storageRef = storage.reference(forURL: K.fileReference).child(fileName)
    task = storageRef.putData(imageData, metadata: nil, completion: { (StorageMetadata, Error) in
        task.removeAllObservers()
        if Error != nil {
            print("error uploadingImage\(Error!.localizedDescription)")
            return
        }else{
            storageRef.downloadURL { (URL, Error) in
                guard let downloadUrl = URL else{
                    return
                }
                compeletion(downloadUrl.absoluteString)
            }
        }
    })
    
}
