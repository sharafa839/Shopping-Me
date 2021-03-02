//
//  ProfileTableViewController.swift
//  Shopping
//
//  Created by ahmed on 15/02/2021.
//  Copyright © 2021 ahmed. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    
    //MARK: - IBoutelets
    @IBOutlet weak var finishRegisteration:UIButton!
    @IBOutlet weak var purchasedHistory:UIButton!
    
    //MARK: - VARS
    var editButtonOutlet :UIBarButtonItem!
    
    //MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        print("didload")
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
   
        
        
             checkISlogin()
checkOnBoardingStatus()
        print("didappear")
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
     // MARK: - Table viewDelegate
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Helper func
    
    func checkISlogin()  {
        if User.currentUser() == nil{
            createRightButtonItem(title: "login")
        }else{
            createRightButtonItem(title: "edit")
            print(User.currentId())
        }
    }
    
    private func checkOnBoardingStatus(){
        
        if User.currentUser() == nil{
            finishRegisteration.setTitle("logged out", for: .normal)
            finishRegisteration.tintColor = .darkGray
            purchasedHistory.tintColor  = .darkGray

            finishRegisteration.isEnabled = false
            purchasedHistory.isEnabled = false
            print("swcond if")

        }else if User.currentUser() != nil{

            if User.currentUser()!.onBoard{
                finishRegisteration.setTitle("Acount is active", for: .normal)
                finishRegisteration.isEnabled = false
                finishRegisteration.tintColor = .darkGray
                print("first if")

            }else{
                finishRegisteration.setTitle("Finish Registeration", for: .normal)
                finishRegisteration.isEnabled = true
                finishRegisteration.tintColor = .red
                print("first else")
            }
                 
        }
        
    }
    
    private func createRightButtonItem(title:String){
        editButtonOutlet = UIBarButtonItem(title: title, style: .plain, target: self , action: #selector(rightButtonPressed))
        self.navigationItem.rightBarButtonItem = editButtonOutlet
    }
    
    @objc private func rightButtonPressed(){
        if editButtonOutlet.title == "login"{
            // showLoginView
            showloginView()
        }else{
            // show view to finish his profile
            editProfile()
        }
    }
    
    private func showloginView(){
        let loginView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "login")
        present(loginView, animated: true, completion: nil)
    }
    private func onBoardView(){
           let onboardView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "onboard")
           present(onboardView, animated: true, completion: nil)
       }
    private func editProfile(){
        
         performSegue(withIdentifier: "EditInfo", sender: self)
    }
    
    @IBAction func finishRegisterationPressed(_ sender: UIButton) {
       // go to on boarding
        onBoardView()
    }
}
