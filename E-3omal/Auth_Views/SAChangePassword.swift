//
//  SAChangePassword.swift
//  E-3omal
//
//  Created by ibrahim M. samak on 7/24/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class SAChangePassword: UIViewController {

    @IBOutlet weak var txtConfirm: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        if(Language.currentLanguage().contains("ar"))
        {
            self.txtConfirm.textAlignment = .right
            self.txtPass.textAlignment = .right
        }
        else
        {
            self.txtConfirm.textAlignment = .left
            self.txtPass.textAlignment = .left
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnChange(_ sender: UIButton)
    {
        if MyTools.tools.connectedToNetwork()
        {
            if txtPass.text?.count == 0{
                self.showOkAlert(title: "Error".localized, message: "Please enter your Password".localized)
            }
            else if (txtConfirm.text?.count)! == 0
            {
                self.showOkAlert(title: "Error".localized, message: "Please enter confirm password".localized)
            }
            else if txtPass.text != txtConfirm.text
            {
                self.showOkAlert(title: "Error".localized, message: "Not match!".localized)
            }
            else
            {
                self.showIndicator()
                MyApi.api.PostupdatePassword(password: txtPass.text!, password_confirmation: txtConfirm.text!)
                { (response, err) in
                    if((err) == nil)
                    {
                        if let JSON = response.result.value as? NSDictionary
                        {
                            let  status = JSON["status"] as? Int
                            if (status == 1)
                            {
                                self.showOkAlertWithComp(title: "Success".localized, message: JSON["message"] as? String ?? "", completion: { (success) in
                                    if(success){
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
        }
        else
        {
            self.showOkAlert(title: "Error".localized, message: "No Internet Connection".localized)
        }
    }
}
