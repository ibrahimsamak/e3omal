//
//  SASearchVC.swift
//  E-3omal
//
//  Created by ibrahim M. samak on 7/12/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh

class SASearchVC: UIViewController , UISearchBarDelegate , UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var txtSearch: UISearchBar!
    @IBOutlet weak var tbl: UITableView!
    
    var entries : NSDictionary!
    var Tcategory : NSArray = []
    var pageIndex = 1
    var isNewDataLoadingFilter: Bool = false
    var elements: NSMutableArray = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.navigationItem.title = "Search".localized
        self.tbl.register(UINib(nibName: "HomeCell", bundle: nil), forCellReuseIdentifier: "HomeCell")
      
        self.setupNavigationBarwithBack()
        self.txtSearch.becomeFirstResponder()
        self.txtSearch.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
        
        let content = self.elements.object(at: indexPath.row) as AnyObject
        let budget = content.value(forKey: "budget") as? Double ?? 0.0
        let title = content.value(forKey: "title") as! String
        let address = content.value(forKey: "address") as! String
        let categoryArr = content.value(forKey: "category") as? NSDictionary ?? [:]
        let categoryName = categoryArr.value(forKey: "title") as? String ?? ""
        
        
        cell.lblTitle.text = title
        cell.lblCategory.text = categoryName
        cell.lblBudget.text = "Budget: ".localized+String(budget)+" K.D".localized
        cell.lblLocation.text = address
        cell.statusView.isHidden = true
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 153.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let content = self.elements.object(at: indexPath.row) as AnyObject
        
        let vc : SAJobDetails = AppDelegate.storyboard.instanceVC()
        vc.content = content
        self.navigationController?.pushViewController(vc, animated: true)
        self.tbl.deselectRow(at: indexPath, animated: true)
    }
    
    func loadData(_ pageIndex:Int)
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            let txtsearch = txtSearch.text?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)

            MyApi.api.GetJobs(page: String(pageIndex), title: txtsearch!)
            {(response, err) in
                if((err) == nil)
                {
                    if let JSON = response.result.value as? NSDictionary
                    {
                        let status = JSON["status"] as? Bool
                        
                        if (status == true)
                        {
                            self.Tcategory = JSON["items"] as! NSArray
                            if (self.Tcategory.count>0)
                            {
                                self.elements.addObjects(from: self.Tcategory.subarray(with: NSMakeRange(0,self.Tcategory.count)))
                                self.isNewDataLoadingFilter = false
                            }
                            else
                            {
                                self.isNewDataLoadingFilter = true
                                
                            }
                            self.tbl.dataSource = self
                            self.tbl.delegate = self
                            self.tbl.reloadData()
                        }
                        else
                        {
                            self.showOkAlert(title: "Error".localized, message: JSON["message"] as? String ?? "")
                        }
                    }
                    else
                    {
                        self.showOkAlert(title: "Error".localized, message: "An Error occurred".localized)
                    }
                    self.hideIndicator()
                }
                else
                {
                    self.hideIndicator()
                    self.showOkAlert(title: "Error".localized, message: "An Error occurred".localized)
                }
            }
        }
        else
        {
            self.showOkAlert(title: "Error".localized, message: "No Internet Connection".localized)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        //Cancel Button Clicked
        self.txtSearch.text = ""
        self.txtSearch.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        if((txtSearch.text?.count)! > 0)
        {
            self.elements.removeAllObjects()
            self.Tcategory = []
            self.tbl.reloadData()
            UIView.animate(withDuration: 0.2){() -> Void in
                self.loadData(1)
            }
            self.txtSearch.resignFirstResponder()
            self.tbl.reloadData()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        if scrollView == self.tbl
        {
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
                if MyTools.tools.connectedToNetwork() {
                    if !isNewDataLoadingFilter {
                        if(self.Tcategory.count>0) {
                            isNewDataLoadingFilter=true
                            self.pageIndex = self.pageIndex + 1
                            self.loadData(self.pageIndex)
                        }
                    }
                }
            }
        }
    }
    

}
