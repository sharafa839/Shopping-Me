 //
//  PurchasedTableViewController.swift
//  Shopping
//
//  Created by ahmed on 17/02/2021.
//  Copyright © 2021 ahmed. All rights reserved.
//

import UIKit
 import JGProgressHUD

class PurchasedTableViewController: UITableViewController {

    
    // MARK: - VARS

    
    var itemArray:[Items]=[]
    let hud = JGProgressHUD(style: .dark)
    
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        tableView.rowHeight = 80
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadItem()

    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemsTableViewCell

        cell.generateCell(item: itemArray[indexPath.row])

        return cell
    }
    
    
    // MARK: - Helpers

    
    private func loadItem(){
        downloadItems(User.currentUser()!.purchsedItems) { (allItem) in
            self.itemArray = allItem
            print("we have\(allItem.count) Items")
            self.tableView.reloadData()
        }
    }

    
    
   
    
    private func emptyItemPurchased(){
        itemArray.removeAll()
       tableView.reloadData()
        updatingUser([K.kPurchedItems : itemArray]) { (error) in
            if self.itemArray.count > 0{
                if error == nil{
                    
                    self.hud.textLabel.text = "Item Purchased is Empty right now"
                    self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0, animated: true)
                    
                }else{
                    print("error\(error!.localizedDescription)")
                }
            }else{
                self.hud.textLabel.text = "Item Purchased is Empty already"
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0, animated: true)
            }
            
        }
       }
     
     
     
    @IBAction func removePurchasedItems(_ sender:UIBarButtonItem){
        emptyItemPurchased()
      
    }
    
 

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
