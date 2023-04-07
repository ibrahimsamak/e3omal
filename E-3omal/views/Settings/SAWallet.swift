//
//  SAWallet.swift
//  E-3omal
//
//  Created by ibrahim M. samak on 7/10/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import BIZPopupView

class SAWallet: UIViewController , UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var arrow: UIImageView!
    @IBOutlet weak var btnarrow: UIButton!
    @IBOutlet weak var lblCharge: UILabel!
    @IBOutlet weak var viewCharge: UIView!
    @IBOutlet weak var lblDeduction: UILabel!
    @IBOutlet weak var viewDeduction: UIView!
    @IBOutlet weak var lblBalance: UILabel!
    @IBOutlet weak var tbl: UITableView!
    
    @IBOutlet weak var btnCharge: UIButton!
    
    var entries : NSDictionary!
    var Tcategory : NSArray = []
    var isCharge = true
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tbl.register(UINib(nibName: "ChargeCell", bundle: nil), forCellReuseIdentifier: "ChargeCell")
        self.tbl.register(UINib(nibName: "DeductionCell", bundle: nil), forCellReuseIdentifier: "DeductionCell")
        
        self.loadDataCharge()
        self.loadData()
        
        if (Language.currentLanguage() == "ar"){
            arrow.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        
        if (MyTools.tools.getUserType() != "customer")
        {
            self.btnCharge.isHidden = false
        }
        else
        {
            self.btnCharge.isHidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(self.Tcategory.count>0)
        {
            return self.Tcategory.count
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if(self.isCharge)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChargeCell", for: indexPath) as! ChargeCell
            let content = self.Tcategory.object(at: indexPath.row) as AnyObject
            let ammount = content.value(forKey: "amount") as? Int ?? 0
            let old = content.value(forKey: "old_balance") as? Int ?? 0
            let new = content.value(forKey: "new_balance") as? Int ?? 0
            let date = content.value(forKey: "created_at") as? String ?? ""
            
            cell.lblAmount.text = String(ammount)+" K.D".localized
            cell.oldBalance.text = String(old)+" K.D".localized
            cell.NewBalance.text = String(new)+" K.D".localized
            cell.lblDate.text = MyTools.tools.convertDateFormater(date: date)
            cell.lblTime.text = MyTools.tools.convertDateToTime(date: date)
            return cell
            
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DeductionCell", for: indexPath) as! DeductionCell
            let content = self.Tcategory.object(at: indexPath.row) as AnyObject
            let ammount = content.value(forKey: "amount") as? Int ?? 0
            let date = content.value(forKey: "created_at") as? String ?? ""
            
            cell.lblDate.text = MyTools.tools.convertDateFormater(date: date)
            cell.lblTime.text = MyTools.tools.convertDateToTime(date: date)
            cell.lblAmount.text = String(ammount)+" K.D".localized
            
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if(self.isCharge)
        {
            return 200.0
        }
        else
        {
            return 80.0
        }
    }
    
    
    @IBAction func changeSegment(_ sender: UIButton)
    {
        if (sender.tag == 1 )
        {
            self.viewDeduction.isHidden = false
            self.viewCharge.isHidden = true
            
            self.Tcategory = []
            self.loadDataDeduct()
            self.lblDeduction.textColor = UIColor.white
            self.lblCharge.textColor = MyTools.tools.colorWithHexString("CAC8D8")
            self.isCharge = false
            //            self.tbl.reloadData()
        }
        else
        {
            self.viewDeduction.isHidden = true
            self.viewCharge.isHidden = false
            
            self.Tcategory = []
            self.loadDataCharge()
            
            
            self.lblCharge.textColor = UIColor.white
            self.lblDeduction.textColor = MyTools.tools.colorWithHexString("CAC8D8")
            self.isCharge = true
            //            self.tbl.reloadData()
        }
    }
    
    @IBAction func btnBack(_ sender: UIButton)
    {
        self.navigationController?.pop(animated: true)
    }
    
    
    func loadDataCharge()
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.GetCharge()
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
                            self.showOkAlert(title: "Error".localized.localized, message: "An Error occurred".localized)
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
    
    
    func loadDataDeduct()
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.GetDeduction()
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
    
    
    func loadData()
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.GetUserProfile() {(response, err) in
                    if((err) == nil)
                    {
                        if let JSON = response.result.value as? NSDictionary
                        {
                            let status = JSON["status"] as? Bool
                            if (status == true)
                            {
                                let json = JSON["items"] as! NSDictionary
                                self.lblBalance.text = String(json.value(forKeyPath: "balance") as? Int ?? 0)+" K.D".localized
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
    
    
    @IBAction func btnChargeaction(_ sender: Any)
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
