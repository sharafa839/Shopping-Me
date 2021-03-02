//
//  SearchViewController.swift
//  Shopping
//
//  Created by ahmed on 21/02/2021.
//  Copyright © 2021 ahmed. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import EmptyDataSet_Swift
class SearchViewController: UIViewController {
    
    //MARK: - IBOutlet

    @IBOutlet weak var searchViewOption: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButtonOutlet: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    //MARK: - Vars
    var searchItems = [Items]()
    var activityIndicator : NVActivityIndicatorView?
    
    
    //MARK: - Life Cycle
    deinit {
        print("deallocated")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.addTarget(self, action: #selector(self.textDidChange(_:)), for: UIControl.Event.editingChanged)
        tableView.tableFooterView = UIView()
        
      searchViewOption.isHidden = true
        tableView.rowHeight = 80
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: view.frame.width/2 - 30, y: view.frame.height/2 - 30, width: 60, height: 60), type: .ballPulse, color: .lightGray, padding:nil)
    }
    

   //MARK: - Helpers
    private func dismissKeyboard(){

        self.view.endEditing(false)
        
    }
    
    
    private func emptyTextFielf(){
        searchTextField.text = ""
    }
    
    @objc func textDidChange(_ textField:UITextField){
        searchButtonOutlet.isEnabled = textField.text != ""
        
        if searchButtonOutlet.isEnabled {
            searchButtonOutlet.backgroundColor = .orange
            
        }else{
            disableSearchButton()
        }
    }
    
    private func disableSearchButton(){
        searchButtonOutlet.isEnabled = false
        searchButtonOutlet.backgroundColor = .darkGray

    }
    private func animateSearchOption(){
        
        UIView.animate(withDuration: 1) {
            self.searchViewOption.isHidden = !self.searchViewOption.isHidden
        }
    }
    
    private func showIndicator(){
        if activityIndicator != nil {
            self.view.addSubview(activityIndicator!)
            activityIndicator?.startAnimating()
        }
    }
    
    private func hideIndicator(){
        if activityIndicator != nil {
            
            self.activityIndicator?.removeFromSuperview()
            activityIndicator?.stopAnimating()

        }
    }
    private func viewItem(_ item:Items){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "itemView")  as! ItemDetailsViewController
        vc.itemSelected = item
    
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    private func searchInFireBase(for Name:String){
        print("getblack1")
        showIndicator()
         print("getblack2")
        searchInAlgolia(searchText: Name) { [weak self](itemIds) in
             print("getblack3")
            downloadItems(itemIds) { (allItems) in
                self?.searchItems = allItems
                self!.tableView.reloadData()
                self?.hideIndicator()
                 print("getblack4")
            }
        }
        
    }
    
    //MARK: - IBAction

    @IBAction func searchBarButton(_ sender: UIBarButtonItem) {
        
        animateSearchOption()
        
    }
    @IBAction func SearchButton(_ sender: UIButton) {
        
        if searchTextField.text != ""{
            
            searchInFireBase(for: searchTextField.text!)
            

            emptyTextFielf()
            animateSearchOption()
            dismissKeyboard()
        }
        
    }
}
extension SearchViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemsTableViewCell
        
        cell.generateCell(item: searchItems[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let item = searchItems[indexPath.row]
        viewItem(item)
    }
    
}
extension SearchViewController:EmptyDataSetSource,EmptyDataSetDelegate{
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
