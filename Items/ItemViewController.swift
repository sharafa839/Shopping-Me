//
//  ItemViewController.swift
//  Shopping
//
//  Created by ahmed on 23/01/2021.
//  Copyright © 2021 ahmed. All rights reserved.
//

import UIKit
import Gallery
import JGProgressHUD
import NVActivityIndicatorView
import InstantSearchClient

class ItemViewController: UIViewController ,UINavigationControllerDelegate{
    
    //Vars
    var category:Category!
    var arrayOfImage:[UIImage?] = []
    var gallery : GalleryController!
    var hud = JGProgressHUD(style: .dark)
    var activittIndicator : NVActivityIndicatorView?
    
    
    // Snippet
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var titletTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(category.id)
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        activittIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height/2-30, width: 50, height: 50), type: .ballPulse, color: .darkGray, padding: nil)
    }

    @IBAction func addPhoto(_ sender: UIButton) {
        arrayOfImage = []
        showGallery()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func addedItem(_ sender: UIBarButtonItem) {
        if checkNotEmpty() {
            saveToFirebase()
        }else{
           /* self.hud.textLabel.text = "please Fill All Fields"
            self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
            self.hud.show(in: self.view)
            self.hud.dismiss(afterDelay: 2.0)*/
           alert()
    }
    }
    @IBAction func taapedAnywhere(_ sender: UITapGestureRecognizer) {
        dismissKeyBoard()
    }
    
    //functions
    func dismissKeyBoard()  {
        
        view.endEditing(false)
    }
    func checkNotEmpty() -> Bool {
        return (titletTextField.text != "" && priceTextField.text != "" && descriptionTextView.text != "")
    
    }
    func alert()  {
        let alert = UIAlertController(title: "WRONG", message: "you have to fill all the field", preferredStyle: .alert)
                   let action = UIAlertAction(title: "ok", style: .cancel) { (UIAlertAction) in
                       self.dismiss(animated: true, completion: nil)
                   }
                   alert.addAction(action)
                   self.present(alert,animated:true ,completion: nil)
               
    }
    func popView()  {
        self.navigationController?.popViewController(animated: true)
       
    }
    
    func saveToFirebase()  {
        showIndicator()
        let item = Items()
        item.id = UUID().uuidString
        item.name = titletTextField.text
        item.price = Double(priceTextField.text!)
        item.description = descriptionTextView.text
        item.categoryId = category.id
        if arrayOfImage.count > 0 {
            uploadImages(images: arrayOfImage, itemId: item.id) { (ImageLinksArray) in
                item.imageLinks = ImageLinksArray
                saveItemsToFirebase(items: item)
                saveItemToAlgolia(item)
                self.popView()
                self.removeIndicator()
                
            }
        }else{
            saveItemsToFirebase(items: item)
            saveItemToAlgolia(item)
            popView()
        }
        
        
    }
    
    

private func showGallery (){
gallery = GalleryController()
    gallery.delegate = self
    Config.tabsToShow = [.cameraTab,.imageTab]
    Config.Camera.imageLimit = 6
    self.present(self.gallery,animated: true,completion: nil)
}

private func showIndicator(){
    if activittIndicator != nil {
        self.view.addSubview(activittIndicator!)
        activittIndicator?.startAnimating()
        
    }
}
    private func removeIndicator(){
        if activittIndicator != nil {
            self.view.removeFromSuperview()
            activittIndicator?.stopAnimating()
            
        }
    }
}




















//MARK: - Gallery
extension ItemViewController:GalleryControllerDelegate{
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        if images.count > 0 {
            Image.resolve(images: images) { (resolvedImage) in
                self.arrayOfImage = resolvedImage
            }
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)

    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)

    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)

    }
    
    
}
//MARK: - Algolia Services

func saveItemToAlgolia(_ item :Items)  {
    let index = AlgoliaService.shared.index
    
    let itemToSave = itemsDictionaryFrom(items: item) as! [String:Any]
    
    index.addObject(itemToSave, withID: item.id, requestOptions: nil) { (content, error) in
        
        
        if error  != nil {
            print("error in saving to alogolia\(error!.localizedDescription)")
        }else{
            print("added to algolia")
        }
    }
    
}

func searchInAlgolia(searchText:String,compeletion:@escaping(_ itemArray:[String])->Void){
    
    let index = AlgoliaService.shared.index
    var resultIds = [String]()
    
    let query = Query(query: searchText)
    query.attributesToRetrieve = ["name","description"]
    
    index.search(query) { (content, error) in
        if error == nil {
            let content = content!["hits"] as! [[String:Any]]
            resultIds = []
            
            for result in content{
                resultIds.append(result["objectID"] as! String)
            }
            compeletion(resultIds)
        }else{
                 print("error in saving to alogolia\(error!.localizedDescription)")
            compeletion(resultIds)
        }
    }
    
}
