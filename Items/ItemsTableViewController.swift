//
//  ItemsTableViewController.swift
//  Shopping
//
//  Created by ahmed on 23/01/2021.
//  Copyright © 2021 ahmed. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift
class ItemsTableViewController: UITableViewController {

   var categorySelected : Category?
    var itemArray : [Items] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(categorySelected!.name)
        tableView.tableFooterView = UIView()
        title=categorySelected?.name
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadItem()
    }

    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as!ItemsTableViewCell
        cell.generateCell(item: itemArray[indexPath.row])
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toViewItem", sender: itemArray[indexPath.row])
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vcDestionation = segue.destination as? ItemDetailsViewController {
            vcDestionation.itemSelected = sender as? Items
        }
        if  segue.identifier == "toAddItem"{
            let vc = segue.destination as! ItemViewController
            vc.category = categorySelected
            
        }
        
    }
    
    func loadItem (){
        downloadItemsFromFireBase(categoryId: categorySelected!.id) { (allItem) in
            print("we have All this item\(allItem.count)")
            self.itemArray = allItem
            self.tableView.reloadData()
        }
        
    }

}
extension ItemsTableViewController:EmptyDataSetSource,EmptyDataSetDelegate{
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "emptyBox")
        
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
       return NSAttributedString(string: "No items to display")
    }
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        return NSAttributedString(string: "please Check back later")
    }
}
