//
//  SAHome.swift
//  E-3omal
//
//  Created by ibrahim M. samak on 7/9/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh

class SAHome: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var btnWallet: UIBarButtonItem!
    
    var btn = UIButton(type: UIButtonType.custom) as UIButton
    let screenSize = UIScreen.main.bounds
    var imagebg = UIImageView()
    var entries : NSDictionary!
    var Tcategory : NSArray = []
    var pageIndex = 1
    var isNewDataLoadingFilter: Bool = false
    var elements: NSMutableArray = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if(MyTools.tools.getUserType() == "customer")
        {
            if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436
            {
                self.addPlusButtonIphoneX()
            }
            else{
                self.addPlusButtonIphone()
            }
        }
        

        self.tbl.register(UINib(nibName: "HomeCell", bundle: nil), forCellReuseIdentifier: "HomeCell")
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = "4E4C7C".color
        self.tbl.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self?.elements.removeAllObjects()
            self?.Tcategory = []
            self?.loadData(1)
            self?.tbl.dg_stopLoading()
            },loadingView: loadingView)
        self.tbl.dg_setPullToRefreshFillColor(UIColor.clear)
        self.tbl.dg_setPullToRefreshBackgroundColor(self.tbl.backgroundColor!)
        self.loadData(1)
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
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.setUpView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
        if(elements.count>0)
        {
            let content = self.elements.object(at: indexPath.row) as AnyObject
            let budget = content.value(forKey: "budget") as? Double ?? 0.0
            let title = content.value(forKey: "title") as! String
            let address = content.value(forKey: "address") as! String
            //            let categoryArr = content.value(forKey: "category") as? NSDictionary ?? [:]
            let categoryName = content.value(forKey: "category_title") as? String ?? ""
            
            cell.lblTitle.text = title
            cell.lblCategory.text = categoryName
            cell.lblBudget.text = "Budget: ".localized+String(budget)+" K.D".localized
            cell.lblLocation.text = address
            cell.statusView.isHidden = true
            return cell
        }
        else
        {
            return cell
        }
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
    
    
    func setUpView()
    {
        self.setupNavigationBar()
        let logoImage:UIImage = UIImage(named: "navlogo")!
        self.navigationItem.titleView = UIImageView(image: logoImage)
        
        let done = UIImageView(image:#imageLiteral(resourceName: "zoom-split"))
        done.frame = CGRect(x: CGFloat(5), y: CGFloat(6), width: CGFloat(20), height: CGFloat(20))
        let doneButton = UIButton(frame: CGRect(x: CGFloat(0), y: CGFloat(6), width: CGFloat(25), height: CGFloat(20)))
        doneButton.addSubview(done)
        doneButton.addTarget(self, action: #selector(self.searchButton(_:)), for: .touchUpInside)
        
        
        let wallet = UIImageView(image:#imageLiteral(resourceName: "wallet"))
        wallet.frame = CGRect(x: CGFloat(5), y: CGFloat(6), width: CGFloat(20), height: CGFloat(20))
        let walletButton = UIButton(frame: CGRect(x: CGFloat(0), y: CGFloat(6), width: CGFloat(25), height: CGFloat(20)))
        walletButton.addSubview(wallet)
        walletButton.addTarget(self, action: #selector(self.WalletButton(_:)), for: .touchUpInside)
        
        
        self.navigationItem.setRightBarButtonItems([UIBarButtonItem(customView: doneButton)], animated: true)
        if(MyTools.tools.getUserType() != "customer")
        {
            self.navigationItem.setLeftBarButtonItems([UIBarButtonItem(customView: walletButton)], animated: true)
        }
    }
    
    func addPlusButtonIphone()
    {
        
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        btn.setTitle("", for: UIControlState.normal)
        btn.frame = CGRect(x:screenWidth - 90 , y: screenHeight - 190 , width: 70, height: 70)
        btn.addTarget(self, action:#selector(addNew), for:.touchUpInside)
        let image1 = UIImage(named:"plusbtn")
        imagebg = UIImageView(image: image1)
        imagebg.frame = CGRect(x:screenWidth - 90 , y: screenHeight - 190, width: 70 , height: 70)
        imagebg.contentMode = .scaleAspectFit
        
        self.view.addSubview(imagebg)
        self.view.addSubview(btn)
    }
    
    func addPlusButtonIphoneX()
    {
        
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        btn.setTitle("", for: UIControlState.normal)
        btn.frame = CGRect(x:screenWidth - 90 , y: screenHeight - 240 , width: 70, height: 70)
        btn.addTarget(self, action:#selector(addNew), for:.touchUpInside)
        let image1 = UIImage(named:"plusbtn")
        imagebg = UIImageView(image: image1)
        imagebg.frame = CGRect(x:screenWidth - 90 , y: screenHeight - 240, width: 70 , height: 70)
        imagebg.contentMode = .scaleAspectFit
        
        self.view.addSubview(imagebg)
        self.view.addSubview(btn)
    }
    
    @objc func addNew(sender: UIButton!)
    {
        //navigation to add new job.
        let vc:SANewJob = AppDelegate.storyboard.instanceVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func searchButton(_ sender: UIButton)
    {
        //navigation to search button
        let vc:SASearchVC = AppDelegate.storyboard.instanceVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func loadData(_ pageIndex:Int)
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.GetJobs(page: String(pageIndex), title: "")
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
    
    @objc func WalletButton(_ sender: UIButton)
    {
        let vc:SAWallet = AppDelegate.storyboard.instanceVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
