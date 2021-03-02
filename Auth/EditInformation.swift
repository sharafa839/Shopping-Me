//
//  EditInformation.swift
//  Shopping
//
//  Created by ahmed on 16/02/2021.
//  Copyright © 2021 ahmed. All rights reserved.
//

import UIKit
import JGProgressHUD
import FirebaseAuth
import NVActivityIndicatorView

class EditInformation: UIViewController {
    // MARK: - IbOutelets

    @IBOutlet weak var firstNameTextField: UITextField!
     @IBOutlet weak var lastNameTextField: UITextField!
     @IBOutlet weak var AdressTextField: UITextField!
    
    
    // MARK: - Vars
    let hud = JGProgressHUD(style: .dark)
    var activityAndicator: NVActivityIndicatorView?
    
    
    // MARK: - Life Cycle


    override func viewDidLoad() {
        super.viewDidLoad()
getUserInfoemation()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         activityAndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width/2-30, y: self.view.frame.height/2 - 30, width: 60, height: 60), type: .ballPulse, color: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), padding: nil)
    }
    
    
    //MARK: -  Helpers
    private func getUserInfoemation(){
        if User.currentUser() != nil{
            let userInfo = User.currentUser()
        
            firstNameTextField.text = userInfo?.firstName
            lastNameTextField.text = userInfo?.lastName
            AdressTextField.text = userInfo?.fullAdress
            
        }
    }
    
    private func dismissKeyBoard(){
        self.view.endEditing(false)
    }

    private func textFieldHaveText()->Bool{
        return (firstNameTextField.text != " " && lastNameTextField.text != " " && AdressTextField.text != " ")
       }
    
    private func showActivityIndicator(){
        if activityAndicator != nil{
            self.view.addSubview(activityAndicator!)
            activityAndicator?.startAnimating()
        }
        
    }
    
    private func hideActivityIndicator(){
        if activityAndicator != nil{
            activityAndicator?.removeFromSuperview()
            activityAndicator?.stopAnimating()
        }
    }
    
        // MARK: - IB Action
    
    @IBAction func logOutButtonPressed(_ sender: UIBarButtonItem) {
        do{
            showActivityIndicator()
                 try Auth.auth().signOut()
            navigationController?.popViewController(animated: true)
            print("skaodlmal")
            
            
        }catch{
            print("error when sign out \(error.localizedDescription)")
        }

        hideActivityIndicator()
    }
    
    @IBAction func saveInformation(_ sender:UIButton){
        dismissKeyBoard()
        if textFieldHaveText(){
             let withValues = [K.kFirstName:firstNameTextField.text! , K.kLastName: lastNameTextField.text! , K.kFullAdress:AdressTextField.text!, K.kFullName: (firstNameTextField.text! + " " + lastNameTextField.text! ), K.kOnBoard : true] as [String:Any]
            updatingUser(withValues) { (error) in
                if error == nil{
                    self.hud.textLabel.text = "Updating Done"
                    self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                    
                    
                }else{
                    print(error!.localizedDescription)
                    self.hud.textLabel.text = "\(String(describing: error?.localizedDescription))"
                    self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                }
                
            }
        }else{
            hud.textLabel.text = " All fields are required"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
        }
    }
    

}
