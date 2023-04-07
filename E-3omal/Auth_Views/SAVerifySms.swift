//
//  SAVerifySms.swift
//  E-3omal
//
//  Created by ibrahim M. samak on 7/4/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import PinCodeTextField

class SAVerifySms: UIViewController {
    @IBOutlet weak var pinCodeTextField: PinCodeTextField!
    @IBOutlet weak var lblMobile: UILabel!
    var mobileNo = ""
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.pinCodeTextField.becomeFirstResponder()
        pinCodeTextField.delegate = self
        pinCodeTextField.keyboardType = .phonePad
        
        let toolbar = UIToolbar()
        let nextButtonItem = UIBarButtonItem(title: NSLocalizedString("Done".localized,
                                                                      comment: ""),
                                             style: .done,
                                             target: self,
                                             action: #selector(pinCodeNextAction))
        toolbar.items = [nextButtonItem]
        toolbar.barStyle = .default
        toolbar.sizeToFit()
        pinCodeTextField.inputAccessoryView = toolbar
        
        
        if(Language.currentLanguage().contains("ar"))
        {
            self.lblMobile.textAlignment = .right
        }
        else
        {
            self.lblMobile.textAlignment = .left
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.lblMobile.text  = mobileNo
        
        //set up transpernt navigation bar with back button
        self.setupTransparentNavigationBar()
    }
    
    override public var prefersStatusBarHidden: Bool {
        return false
    }
    
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    @objc private func pinCodeNextAction()
    {
        if pinCodeTextField.text?.count != 4
        {
            self.showOkAlert(title: "Error".localized, message: "Please enter 4-digits".localized)
        }
        else{
            self.CheckSMSCode(code: pinCodeTextField.text!)
        }
    }
    
    @IBAction func btnResendCode(_ sender: UIButton)
    {
        self.resendCode(Code: "")
    }
    
    func CheckSMSCode (code:String)
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.PostCheckCode(code: code, mobile: lblMobile.text!)
            { (response, err) in
                if((err) == nil)
                {
                    if let JSON = response.result.value as? NSDictionary
                    {
                        let  status = JSON["status"] as? Int
                        if (status == 1)
                        {
                            //redirect to tabbar depend on role
                            let UserArray = JSON["items"] as? NSDictionary

                            let ns = UserDefaults.standard
                            let CurrentUser:NSDictionary =
                                [
                                    "email":UserArray?.value(forKey: "email") as! String , "id":UserArray?.value(forKey: "id") as! Int, "name":UserArray?.value(forKey: "name") as! String ,
                                    "profile_image": UserArray?.value(forKey: "profile_image") as? String ?? ""  ,
                                    "mobile":UserArray?.value(forKey: "mobile") as! String ,
                                    "access_token":UserArray?.value(forKey: "access_token") as! String,
                                    "type": UserArray?.value(forKey: "type") as! String
                            ]
                            
                            ns.setValue(CurrentUser, forKey: "CurrentUser")
                            ns.synchronize()
                            
                            let vc : SAMainTabbar = AppDelegate.storyboard.instanceVC()
                            let appDelegate = UIApplication.shared.delegate
                            appDelegate?.window??.rootViewController = vc
                            appDelegate?.window??.makeKeyAndVisible()
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
    
    
    func resendCode(Code:String)
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.PostRequestNewCode(code: "", mobile: lblMobile.text!)
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
        else
        {
            self.showOkAlert(title: "Error".localized, message: "No Internet Connection".localized)
        }
    }
}


extension SAVerifySms: PinCodeTextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: PinCodeTextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: PinCodeTextField) {
        
    }
    
    func textFieldValueChanged(_ textField: PinCodeTextField)
    {
        let value = textField.text ?? ""
        if(textField.text?.count == 4)
        {
            self.CheckSMSCode(code:value)
        }
    }
    
    func textFieldShouldEndEditing(_ textField: PinCodeTextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: PinCodeTextField) -> Bool {
        return true
    }
}
