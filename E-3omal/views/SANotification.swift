//
//  SANotification.swift
//  E-3omal
//
//  Created by ibrahim M. samak on 7/18/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh

class SANotification: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tbl: UITableView!
    var Tcategory: NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.navigationItem.title = "Notifications".localized
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red:1, green:1, blue:1, alpha:1)
        self.tbl.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self?.Tcategory = []
            self?.tbl.reloadData()
            self?.loadData()
            self?.tbl.dg_stopLoading()
            },
                                                      loadingView: loadingView)
        self.tbl.dg_setPullToRefreshFillColor(MyTools.tools.colorWithHexString("4E4C7C"))
        self.tbl.dg_setPullToRefreshBackgroundColor(self.tbl.backgroundColor!)
        self.loadData()
        self.tbl.tableFooterView = UIView()
    }
    
    
    deinit
    {
        if((self.tbl) != nil)
        {
            self.tbl.dg_removePullToRefresh()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.Tcategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NotificationCell
        let content = self.Tcategory.object(at: indexPath.row) as AnyObject
        let message = content.value(forKey: "message") as? String ?? ""
        
        
        cell.lblmsg.text = message
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let content = self.Tcategory.object(at: indexPath.row) as AnyObject

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc : SAMainTabbar = AppDelegate.storyboard.instanceVC()
        vc.selectedIndex = 2
        appDelegate.window?.rootViewController = vc
        appDelegate.window?.makeKeyAndVisible()
    }
    
    
    
    func loadData()
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.GetNotificationList()
                {(response, err) in
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
    
}
