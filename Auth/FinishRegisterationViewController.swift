//
//  FinishRegisterationViewController.swift
//  Shopping
//
//  Created by ahmed on 16/02/2021.
//  Copyright © 2021 ahmed. All rights reserved.
//

import UIKit
import JGProgressHUD

class FinishRegisterationViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var firstName:UITextField!
    @IBOutlet weak var lastName:UITextField!
    @IBOutlet weak var address:UITextField!
    @IBOutlet weak var doneButton:UIButton!

    //MARK: - VARS
    let hud = JGProgressHUD(style: .dark)


    override func viewDidLoad() {
        super.viewDidLoad()

        firstName.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        lastName.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        address.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        

        
    }
    
    //MARK:  - IBAction

    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismissView()
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
      
        OnBoarding()
    }
    
    //MARK: -  Helpers
    
    private func dismissView(){
        self.dismiss(animated: true, completion: nil)
    }
    @objc private func textFieldDidChange(_ textField:UITextField){
        updateDoneButtonStaus()
    }
    private func updateDoneButtonStaus(){
        if firstName.text != "" && lastName.text != "" && address.text != "" {
            doneButton.isEnabled = true
            doneButton.backgroundColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
           
        }else{
            doneButton.isEnabled = false
                       doneButton.backgroundColor = .darkGray
        }
    }
    private func dismissKeyBoard(){
        self.view.endEditing(false)
    }
    
    private func OnBoarding(){
        dismissKeyBoard()
        let withValues = [K.kFirstName:firstName.text! , K.kLastName: lastName.text! , K.kFullAdress:address.text!, K.kFullName: (firstName.text! + " " + lastName.text! ), K.kOnBoard : true] as [String:Any]
        
        updatingUser(withValues) { (error) in
            if error == nil{
                self.hud.textLabel.text = "Done"
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
                self.dismissView()
            }else{
                print(error!.localizedDescription)
                self.hud.textLabel.text = "Not Update"
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
            
        }
    }
}

