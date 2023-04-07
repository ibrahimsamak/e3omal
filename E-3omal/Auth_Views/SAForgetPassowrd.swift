//
//  SAForgetPassowrd.swift
//  E-3omal
//
//  Created by ibrahim M. samak on 7/5/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class SAForgetPassowrd: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(Language.currentLanguage().contains("ar"))
        {
            self.txtEmail.textAlignment = .right
        }
        else
        {
            self.txtEmail.textAlignment = .left
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        //set up transpernt navigation bar with back button
        self.setupTransparentNavigationBar()
    }
    
    @IBAction func btnResetPassword(_ sender: UIButton)
    {
        if MyTools.tools.connectedToNetwork()
        {
            if txtEmail.text?.count == 0{
                self.showOkAlert(title: "Error".localized, message: "Please enter your email".localized)
            }
            if !MyTools.tools.validateEmail(candidate: txtEmail.text!)
            {
                self.showOkAlert(title: "Error".localized, message: "Please enter a valid email".localized)
            }
            else
            {
                self.showIndicator()
                MyApi.api.PostForgetPassword(email: txtEmail.text!)
                { (response, err) in
                    if((err) == nil)
                    {
                        if let JSON = response.result.value as? NSDictionary
                        {
                            let  status = JSON["status"] as? Int
                            if (status == 1)
                            {
                                self.showOkAlert(title: "Success".localized, message: JSON["message"] as? String ?? "")
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
        }
        else
        {
            self.showOkAlert(title: "Error".localized, message: "No Internet Connection".localized)
        }
    }
}
