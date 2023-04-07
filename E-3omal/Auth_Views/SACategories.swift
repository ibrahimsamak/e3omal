//
//  SACategories.swift
//  E-3omal
//
//  Created by ibrahim M. samak on 7/7/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

protocol CategoryProtocol
{
    func sendCategory(CateogryNameArr:[String] , CategoryArr :[Int])
}

class SACategories: UIViewController ,UITableViewDelegate  , UITableViewDataSource  {
    
    @IBOutlet weak var tbl: UITableView!
    var delegate:CategoryProtocol?
    
    var entries : NSDictionary!
    var Tcategory : NSArray = []
    var elements: NSMutableArray = []
    var isContractor = true
    var selectedCategoryID : NSMutableArray = []
    var selectedCategoryName : NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBarwithBack()
        self.setupDoneButton()
        self.loadData()
        self.tbl.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.Tcategory.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! catCell
        let content = self.Tcategory.object(at: indexPath.row) as AnyObject
        let s_name = content.value(forKey: "title") as! String
        let id = content.value(forKey: "id") as! Int
        
        cell.lblTitle.text = s_name
        
        if (self.selectedCategoryID.contains(id))
        {
            cell.img.isHidden = false
        }
        else
        {
            cell.img.isHidden  = true
        }
        
        if(Language.currentLanguage().contains("ar")){
            cell.textLabel?.textAlignment = .right
        }
        else{
            cell.textLabel?.textAlignment = .left
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath)
        let content = self.Tcategory.object(at: indexPath.row) as AnyObject
        let  id  = content.value(forKey: "id") as! Int
        let  title  = content.value(forKey: "title") as! String
        
        if(self.isContractor)
        {
            //multi selection
            if (!selectedCategoryID.contains(id))
            {
                self.selectedCategoryID.add(id)
                self.selectedCategoryName.add(title)
            }
            else{
                self.selectedCategoryID.remove(id)
                self.selectedCategoryName.remove(title)
            }
            self.tbl.reloadData()
        }
        else{
            //single selection
            self.selectedCategoryID.add(id)
            self.selectedCategoryName.add(title)
            self.navigationController?.popViewControllerWithHandler {
                self.delegate?.sendCategory(CateogryNameArr:self.selectedCategoryName as! [String] ,CategoryArr: self.selectedCategoryID as! [Int])
            }
        }
    }
    
    
    func loadData()
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.GetCategories() {(response, err) in
                if((err) == nil)
                {
                    if let JSON = response.result.value as? NSDictionary
                    {
                        let status = JSON["status"] as? Bool
                        
                        if (status == true)
                        {
                            self.Tcategory = JSON["items"] as! NSArray
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
    
    func setupDoneButton()
    {
        let done = UIImageView(image:#imageLiteral(resourceName: "checkedIcon"))
        done.frame = CGRect(x: CGFloat(0), y: CGFloat(10), width: CGFloat(22), height: CGFloat(20))
        let doneButton = UIButton(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(25), height: CGFloat(20)))
        doneButton.addSubview(done)
        doneButton.addTarget(self, action: #selector(self.doneButton(_:)), for: .touchUpInside)
        
        self.navigationItem.setRightBarButtonItems([UIBarButtonItem(customView: doneButton)], animated: true)
    }
    
    @objc func doneButton(_ sender: UIButton)
    {
        self.navigationController?.popViewControllerWithHandler
            {
                self.delegate?.sendCategory(CateogryNameArr:self.selectedCategoryName as! [String] ,CategoryArr: self.selectedCategoryID as! [Int])
        }
    }
}
