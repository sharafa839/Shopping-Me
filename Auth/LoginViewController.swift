//
//  LoginViewController.swift
//  Shopping
//
//  Created by ahmed on 14/02/2021.
//  Copyright © 2021 ahmed. All rights reserved.
//

import UIKit
import JGProgressHUD
import NVActivityIndicatorView
class LoginViewController: UIViewController {
    
    //MARK: - VARS
    let hud = JGProgressHUD(style: .dark)
    var activityAndicator:NVActivityIndicatorView?
    
    //MARK: - IBoutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activityAndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width/2-30, y: self.view.frame.height/2 - 30, width: 60, height: 60), type: .ballPulse, color: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), padding: nil)
        
    }
    //MARK: - IBAction
    
    @IBAction func pressedCancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressedLoginButton(_ sender:UIButton){
        
        if isEmpty(){
            loginUser()
            navigationController?.popViewController(animated: true)
            
        }else{
            hud.textLabel.text = "all fields required"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)

        }
    }
    @IBAction func pressedSignUpButton(_ sender:UIButton){
        
        if isEmpty(){
            registerUser()
            navigationController?.popViewController(animated: true)

            
        }else{
            hud.textLabel.text = "all fields required"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
            
        }
        
    }
    @IBAction func pressedForgotPassword(_ sender:UIButton){
        if !emailTextField.text!.isEmpty {
            
            resetPassword()
        }else{
            // tell user to write his mail
            hud.textLabel.text = "write your email please"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
        }
    }
    @IBAction func pressedResendEmail(_ sender:UIButton){
        if !emailTextField.text!.isEmpty{
            resendEmailVerfication(email: emailTextField.text!)
        }
        else{
            hud.textLabel.text = "write your email please"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
        }
        
    }
    
    //MARK: - Help function
    private func isEmpty()->Bool{
        return (emailTextField.text != " " && passwordTextfield.text != " " )
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
    private func dismissView(){
        self.dismiss(animated: true, completion: nil)
    }
    private func resetPassword(){
        User.resetPassword(email: emailTextField.text!) { (error) -> Void in
            print("45")
            if error == nil {
                self.hud.textLabel.text = "email reset password sent"
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
                
            }else{
                self.hud.textLabel.text = "error\(String(describing: error?.localizedDescription))"
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
        }
    }
    
    private func resendEmailVerfication(email:String){
       User.resendEmailVerfication(email: email) { (error) in
            if error == nil {
                print("NOERROR IN RESEEND EMAIL")
                self.hud.textLabel.text = "email verfication sent !"
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
                
            }else{
                self.hud.textLabel.text = "error\(String(describing: error?.localizedDescription))"
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
        }
    }

    
    //MARK: - Register USER
    private func registerUser(){
        showActivityIndicator()
        User.registerUserWith(email: emailTextField.text!, password: passwordTextfield.text!) { (error) in
            if error == nil{
                self.hud.textLabel.text = "verification email sent"
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
                self.hideActivityIndicator()
            }else{
                self.hud.textLabel.text = "faild in register\(String(describing: error?.localizedDescription))"
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
                self.hideActivityIndicator()
            }
        }
    }
    
    //MARK: - loginUser
    private func loginUser(){
        showActivityIndicator()
        User.loginUserWith(email: emailTextField.text!, password: passwordTextfield.text!) { (error, isEmailVerfied) in
            if error == nil{
                if isEmailVerfied{
                    
                    self.dismissView()
                    print("Email is verification")
                    print(User.currentId())
                }else{
                    self.hud.textLabel.text = "please verify your email"
                    self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                }
            }else{
                self.hud.textLabel.text = "error loging in the user \(String(describing: error?.localizedDescription))"
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
            self.hideActivityIndicator()
        }
    }
    
    
    
    /*func showProfile()  {
        
        let loginVc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "profile")
        
        present(loginVc, animated: true, completion: nil)
    }*/
}
