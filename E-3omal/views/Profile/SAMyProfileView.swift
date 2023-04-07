//
//  SAMyProfileView.swift
//  E-3omal
//
//  Created by ibrahim M. samak on 7/10/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import BIZPopupView
import SDWebImage
import DGElasticPullToRefresh
import BIZPopupView


class SAMyProfileView: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var btnChange: UIButton!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblmsg: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var infoView: UIView!
    
    var btn = UIButton(type: UIButtonType.custom) as UIButton
    let screenSize = UIScreen.main.bounds
    var imagebg = UIImageView()
    var entries : NSDictionary!
    var Tcategory : NSArray = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.tbl.register(UINib(nibName: "HomeCell", bundle: nil), forCellReuseIdentifier: "HomeCell")
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = "4E4C7C".color
        self.tbl.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self?.Tcategory = []
            self?.loadData()
            self?.tbl.dg_stopLoading()
            },loadingView: loadingView)
        self.tbl.dg_setPullToRefreshFillColor(UIColor.clear)
        self.tbl.dg_setPullToRefreshBackgroundColor(self.tbl.backgroundColor!)
        
        
        if(Language.currentLanguage().contains("ar"))
        {
            self.lblmsg.textAlignment = .right
            self.lblName.textAlignment = .right
            self.lblMobile.textAlignment = .right
        }
        else
        {
            self.lblmsg.textAlignment = .left
            self.lblName.textAlignment = .left
            self.lblMobile.textAlignment = .left
        }
        
        if (MyTools.tools.getUserType() != "customer")
        {
            self.btnChange.isHidden = false
        }
        else
        {
            self.btnChange.isHidden = true
        }
        
        self.loadData()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        let ns = UserDefaults.standard
        ns.removeObject(forKey: "notificationType")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.Tcategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
        
        let content = self.Tcategory.object(at: indexPath.row) as AnyObject
        let budget = content.value(forKey: "budget") as? Double ?? 0.0
        let status = content.value(forKey: "status") as? String ?? ""
        let customer_name = content.value(forKey: "customer_name") as? String ?? ""
        
        let jobDetails = content.value(forKey: "job") as? NSDictionary ?? [:]
        let type = jobDetails.value(forKey: "category_title") as? String ?? ""
        let title = jobDetails.value(forKey: "title") as? String ?? ""
        
        cell.lblTitle.text = title
        cell.lblCategory.text = type
        cell.lblBudget.text = "Budget: ".localized+String(budget)+" K.D".localized
        cell.flipIcon.image = #imageLiteral(resourceName: "Group")
        cell.lblStatus.text = status.localized
        cell.lblLocation.text = customer_name
       
        //wating, accepted, payment, approved, done
        switch status
        {
        case "waiting":
            cell.statusIcon.image = #imageLiteral(resourceName: "Group 9")
            cell.lblStatus.textColor = "9A98AE".color
        case "payment":
            if(MyTools.tools.getUserType() == "customer"){
                cell.statusIcon.image = #imageLiteral(resourceName: "pending")
                cell.lblStatus.text = "Pending".localized
                cell.lblStatus.textColor = "9A98AE".color
            }
            else
            {
                cell.statusIcon.image = #imageLiteral(resourceName: "credit-card")
                cell.lblStatus.text = status.localized
                cell.lblStatus.textColor = "9A98AE".color
            }
        case "approved":
            cell.statusIcon.image = #imageLiteral(resourceName: "checked")
            cell.lblStatus.textColor = "9A98AE".color
        case "done":
            cell.statusIcon.image = #imageLiteral(resourceName: "DoneShape")
            cell.lblStatus.textColor = "9A98AE".color
        case "reject":
            cell.statusIcon.image = #imageLiteral(resourceName: "reject")
            cell.lblStatus.textColor = "F31B22".color
        default:
             cell.statusIcon.image = UIImage()
        }
        
        if(status == "done")
        {
            cell.statusView.layer.cornerRadius = 0
            cell.statusView.layer.masksToBounds = true
            cell.statusView.layer.borderWidth = 0
            cell.statusView.layer.borderColor = UIColor.clear.cgColor
            cell.statusView.backgroundColor = UIColor.clear
        }
      
        if(status == "reject"){
            cell.statusView.layer.cornerRadius = 0
            cell.statusView.layer.masksToBounds = true
            cell.statusView.layer.borderWidth = 0
            cell.statusView.layer.borderColor = UIColor.clear.cgColor
            cell.statusView.backgroundColor = UIColor.clear
        }
        
        if(status == "waiting" && MyTools.tools.getUserType() != "customer")
        {
            cell.statusView.layer.cornerRadius = 0
            cell.statusView.layer.masksToBounds = true
            cell.statusView.layer.borderWidth = 0
            cell.statusView.layer.borderColor = UIColor.clear.cgColor
            cell.statusView.backgroundColor = UIColor.clear
        }
        if(status == "payment" && MyTools.tools.getUserType() == "customer")
        {
            cell.statusView.layer.cornerRadius = 0
            cell.statusView.layer.masksToBounds = true
            cell.statusView.layer.borderWidth = 0
            cell.statusView.layer.borderColor = UIColor.clear.cgColor
            cell.statusView.backgroundColor = UIColor.clear
        }
        if(status == "approved" && MyTools.tools.getUserType() != "customer")
        {
            cell.statusView.layer.cornerRadius = 0
            cell.statusView.layer.masksToBounds = true
            cell.statusView.layer.borderWidth = 0
            cell.statusView.layer.borderColor = UIColor.clear.cgColor
            cell.statusView.backgroundColor = UIColor.clear
        }
        
        if(status == "waiting" && MyTools.tools.getUserType() == "customer")
        {
            cell.statusView.layer.cornerRadius = 5
            cell.statusView.layer.masksToBounds = true
            cell.statusView.layer.borderWidth = 1
            cell.statusView.layer.borderColor = UIColor.gray.cgColor
            cell.statusView.backgroundColor = "FBFBFF".color
        }
        if(status == "payment" && MyTools.tools.getUserType() != "customer")
        {
            cell.statusView.layer.cornerRadius = 5
            cell.statusView.layer.masksToBounds = true
            cell.statusView.layer.borderWidth = 1
            cell.statusView.layer.borderColor = UIColor.gray.cgColor
            cell.statusView.backgroundColor = "FBFBFF".color
        }
        if(status == "approved" && MyTools.tools.getUserType() == "customer")
        {
            cell.statusView.layer.cornerRadius = 5
            cell.statusView.layer.masksToBounds = true
            cell.statusView.layer.borderWidth = 1
            cell.statusView.layer.borderColor = UIColor.gray.cgColor
            cell.statusView.backgroundColor = "FBFBFF".color
        }
        
        cell.btnChangeStatus.tag = indexPath.row
        cell.btnChangeStatus.addTarget(self, action: #selector(self.changeStatus(_:)), for: .touchUpInside)
    
        cell.btnProviderProfile.tag = indexPath.row
        cell.btnProviderProfile.addTarget(self, action: #selector(self.ProviderProfile(_:)), for: .touchUpInside)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 153.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let content = self.Tcategory.object(at: indexPath.row) as AnyObject
        let jobDetails = content.value(forKey: "job") as? NSDictionary ?? [:]
        
        
        let vc : SAJobDetails = AppDelegate.storyboard.instanceVC()
        vc.content = jobDetails as AnyObject
        self.navigationController?.pushViewController(vc, animated: true)
        self.tbl.deselectRow(at: indexPath, animated: true)
    }
    
    
    func setUpView()
    {
        self.setupNavigationBar()
        let done = UIImageView(image:#imageLiteral(resourceName: "pencil"))
        done.frame = CGRect(x: CGFloat(5), y: CGFloat(6), width: CGFloat(20), height: CGFloat(20))
        let doneButton = UIButton(frame: CGRect(x: CGFloat(0), y: CGFloat(6), width: CGFloat(25), height: CGFloat(20)))
        doneButton.addSubview(done)
        doneButton.addTarget(self, action: #selector(self.editButton(_:)), for: .touchUpInside)
        
        self.navigationItem.setRightBarButtonItems([UIBarButtonItem(customView: doneButton)], animated: true)
    }
    
    @objc func ProviderProfile(_ sender: UIButton)
    {
        // go to provider profile
        if(MyTools.tools.getUserType() == "customer")
        {
            let index = sender.tag
            let content = self.Tcategory.object(at: index) as AnyObject
            let provider_id = content.value(forKey: "provider_id") as! Int
            let vc:SAProviderProfile = AppDelegate.storyboard.instanceVC()
            vc.userId = provider_id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func changeStatus(_ sender: UIButton)
    {
        // go to provider profile
        let index = sender.tag
        let content = self.Tcategory.object(at: index) as AnyObject
        let job_id = content.value(forKey: "job_id") as? Int ?? 0
        let offerId = content.value(forKey: "id") as? Int ?? 0
        let status = content.value(forKey: "status") as? String ?? ""
        let providerID = content.value(forKey: "provider_id") as? Int ?? 0
        
        if(status == "waiting" && MyTools.tools.getUserType() == "customer")
        {
            //open vc when waiting and loged in by customer
            self.openPopUpView(3,offerId,job_id)
        }
        if(status == "payment" && MyTools.tools.getUserType() != "customer")
        {
            //request to minus from wallet
            self.PostPayment(job_id,offerId,"payment")
        }
        if(status == "approved" && MyTools.tools.getUserType() == "customer")
        {
            // opent rate
            self.openPopUpView(2,offerId,job_id)
        }
    }
    
    @objc func editButton(_ sender: UIButton)
    {
        //navigation to edit button
        
        if(MyTools.tools.getUserType() != "customer"){
            let vc:SAEditProfileHandyman = AppDelegate.storyboard.instanceVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            let vc:SACustomerEditProfile = AppDelegate.storyboard.instanceVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    func PostPayment(_ job_id:Int,_ offer_id:Int , _ status:String)
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.postAcceptorRejectByHandyMan(job_id: job_id, offer_id: offer_id, status: status)
                {(response, err) in
                    if((err) == nil)
                    {
                        if let JSON = response.result.value as? NSDictionary
                        {
                            let status = JSON["status"] as? Bool
                            if (status == true)
                            {
                                self.showOkAlertWithComp(title: "Success".localized, message: JSON["message"] as? String ?? "", completion: { (success) in
                                    if(success)
                                    {
                                        self.hideIndicator()
                                    }
                                })
                            }
                            else
                            {
                                self.showOkAlertWithComp(title: "Success".localized, message: JSON["message"] as? String ?? "", completion: { (success) in
                                    if(success)
                                    {
                                        //go to recharge view
                                        self.hideIndicator()
                                        
                                        let vc:SAPopUp = AppDelegate.storyboard.instanceVC()
                                        vc.type = 1
                                        vc.isCharge = true
                                        let screenSize = UIScreen.main.bounds
                                        let screenWidth = screenSize.width
                                        let screenHeight = screenSize.height
                                        let popupViewController = BIZPopupViewController(contentViewController: vc, contentSize: CGSize(width: screenWidth, height: screenHeight))
                                        popupViewController?.showDismissButton = true
                                        popupViewController?.enableBackgroundFade = true
                                        self.present(popupViewController!, animated: true, completion: nil)
                                    }
                                })
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
    
    
    func loadData()
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.GetUserProfile()
                {(response, err) in
                    if((err) == nil)
                    {
                        if let JSON = response.result.value as? NSDictionary
                        {
                            let status = JSON["status"] as? Bool
                            if (status == true)
                            {
                                let json = JSON["items"] as! NSDictionary
                                if(MyTools.tools.getUserType() == "customer"){
                                    self.Tcategory = json.value(forKey: "offers_customer")as! NSArray
                                }
                                else
                                {
                                    self.Tcategory = json.value(forKey: "offers")as! NSArray
                                }
                                self.lblName.text = json.value(forKeyPath: "name") as? String
                                self.lblMobile.text = json.value(forKeyPath: "mobile") as? String
                                let img = json.value(forKeyPath: "profile_image") as? String ?? ""
                                self.lblmsg.text = json.value(forKeyPath: "email") as? String ?? ""
                                self.img.sd_setImage(with: URL(string: img)!, placeholderImage: UIImage(named: "Avatar")!, options: SDWebImageOptions.refreshCached)

                                self.infoView.isHidden = false
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
    
    func openPopUpView(_ type:Int, _ offer_id:Int , _ job_id:Int)
    {
        let vc:SAPopUp = AppDelegate.storyboard.instanceVC()
        vc.type = type
        vc.offer_id = offer_id
        vc.provider_id = offer_id
        vc.job_id = job_id
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let popupViewController = BIZPopupViewController(contentViewController: vc, contentSize: CGSize(width: screenWidth, height: screenHeight))
        popupViewController?.showDismissButton = true
        popupViewController?.enableBackgroundFade = true
        self.present(popupViewController!, animated: true, completion: nil)
    }

    
    @IBAction func btnCharge(_ sender: UIButton)
    {
        let vc:SAPopUp = AppDelegate.storyboard.instanceVC()
        vc.type = 1
        vc.isCharge = true
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let popupViewController = BIZPopupViewController(contentViewController: vc, contentSize: CGSize(width: screenWidth, height: screenHeight))
        popupViewController?.showDismissButton = true
        popupViewController?.enableBackgroundFade = true
        self.present(popupViewController!, animated: true, completion: nil)
    }
}
