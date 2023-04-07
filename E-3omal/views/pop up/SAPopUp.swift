//
//  SAPopUp.swift
//  E-3omal
//
//  Created by ibrahim M. samak on 7/10/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class SAPopUp: UIViewController
{
    @IBOutlet weak var action: UIView!
    @IBOutlet weak var price: UIView!
    @IBOutlet weak var rate: UIView!
    @IBOutlet weak var txtPrice: UITextField!
    
    @IBOutlet weak var rateView: FloatRatingView!
    
    var type = 1
    var job_id = 0
    var offer_id = 0
    var provider_id = 0
    
    var isCharge = false
    var url = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if(type == 1)
        {
            self.price.isHidden = false
        }
        if(type == 2){
            self.rate.isHidden = false
        }
        if(type == 3){
            self.action.isHidden = false
        }
        
        if(self.isCharge)
        {
            self.txtPrice.placeholder = "Amount".localized
        }
        
        if(Language.currentLanguage().contains("ar"))
        {
            self.txtPrice.textAlignment = .right
        }
        else
        {
            self.txtPrice.textAlignment = .left
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    @IBAction func btnClose(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSendPrice(_ sender: UIButton)
    {
        if(self.isCharge)
        {
            self.ChargePayment()
        }
        else{
            self.Price()
        }
    }
    
    
    @IBAction func btnReate(_ sender: UIButton)
    {
        // rate provider
        self.func_rate()
    }
    
    @IBAction func btnAction(_ sender: UIButton)
    {
        if(sender.tag == 1){
            //accept
            self.actions("accept")
        }
        else{
            //reject
            self.actions("reject")
        }
    }
    
    
    func ChargePayment()
    {
        if MyTools.tools.connectedToNetwork()
        {
            if txtPrice.text?.count == 0{
                self.showOkAlert(title: "Error".localized, message: "Please enter amount to charge your account".localized)
            }
            else
            {
                self.showIndicator()
                MyApi.api.postPayment(amount: txtPrice.text!)
                { (response, err) in
                    if((err) == nil)
                    {
                        if let JSON = response.result.value as? NSDictionary
                        {
                            let  status = JSON["status"] as? Int
                            if (status == 1)
                            {
                                let items = JSON["items"] as! NSArray
                                let url = items[0] as! String
                                self.showOkAlertWithComp(title: "Success".localized, message: JSON["message"] as? String ?? "", completion: { (success) in
                                    if(success)
                                    {
                                        self.hideIndicator()
                                        self.dismiss(animated: true, completion: {
                                            guard let url = URL(string: url) else {
                                                return
                                            }
                                            if #available(iOS 10.0, *) {
                                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                            } else {
                                                UIApplication.shared.openURL(url)
                                            }
                                        })
                                    }
                                })
                            }
                            else
                            {
                                self.hideIndicator()
                                self.showOkAlert(title: "Error".localized, message: JSON["message"] as? String ?? "")
                            }
                            self.hideIndicator()
                        }
                    }
                    else
                    {
                        self.hideIndicator()
                        self.showOkAlert(title: "Error".localized, message: "An Error occurred".localized)
                    }
                }
            }
        }
        else
        {
            self.showOkAlert(title: "Error".localized, message: "No Internet Connection".localized)
        }
    }
    
    
    func Price()
    {
        if MyTools.tools.connectedToNetwork()
        {
            if txtPrice.text?.count == 0{
                self.showOkAlert(title: "Error".localized, message: "Please enter price ammount".localized)
            }
            else
            {
                self.showIndicator()
                MyApi.api.PostMakeOffer(job_id: self.job_id, budget: Int(txtPrice.text!)!)
                { (response, err) in
                    if((err) == nil)
                    {
                        if let JSON = response.result.value as? NSDictionary
                        {
                            let  status = JSON["status"] as? Int
                            if (status == 1)
                            {
                                self.showOkAlertWithComp(title: "Success".localized, message: JSON["message"] as? String ?? "", completion: { (success) in
                                    if(success)
                                    {
                                        self.hideIndicator()
                                        self.dismiss(animated: true, completion: nil)
                                    }
                                })
                            }
                            else
                            {
                                self.hideIndicator()
                                self.showOkAlert(title: "Error".localized, message: JSON["message"] as? String ?? "")
                            }
                            self.hideIndicator()
                        }
                    }
                    else
                    {
                        self.hideIndicator()
                        self.showOkAlert(title: "Error".localized, message: "An Error occurred".localized)
                    }
                }
            }
        }
        else
        {
            self.showOkAlert(title: "Error".localized, message: "No Internet Connection".localized)
        }
    }
    
    
    func actions(_ status:String)
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.postAcceptorRejectBbCustomer(job_id: self.job_id, offer_id: self.offer_id, status: status)
            { (response, err) in
                if((err) == nil)
                {
                    if let JSON = response.result.value as? NSDictionary
                    {
                        let  status = JSON["status"] as? Int
                        if (status == 1)
                        {
                            self.showOkAlertWithComp(title: "Success".localized, message: JSON["message"] as? String ?? "", completion: { (success) in
                                if(success)
                                {
                                    self.hideIndicator()
                                    self.dismiss(animated: true, completion: nil)
                                }
                            })
                        }
                        else
                        {
                            self.showOkAlert(title: "Error".localized, message: JSON["message"] as? String ?? "")
                        }
                        self.hideIndicator()
                    }
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
    
    
    func func_rate()
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.postAcceptorRejectBbCustomer(job_id: self.job_id, offer_id: self.offer_id, status: "rate")
            { (response, err) in
                if((err) == nil)
                {
                    if let JSON = response.result.value as? NSDictionary
                    {
                        let  status = JSON["status"] as? Int
                        if (status == 1)
                        {
                            self.showOkAlertWithComp(title: "Success".localized, message: JSON["message"] as? String ?? "", completion: { (success) in
                                if(success)
                                {
                                    self.hideIndicator()
                                    self.dismiss(animated: true, completion: nil)
                                }
                            })
                        }
                        else
                        {
                            self.hideIndicator()
                            self.showOkAlert(title: "Error".localized, message: JSON["message"] as? String ?? "")
                        }
                        self.hideIndicator()
                    }
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
