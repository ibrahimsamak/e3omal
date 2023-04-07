//
//  SALogin.swift
//  E-3omal
//
//  Created by ibrahim M. samak on 7/5/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import Firebase

class SALogin: UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
  
    var entries : NSDictionary!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTransparentNavigationBar()
        
        if(Language.currentLanguage().contains("ar"))
        {
            self.txtEmail.textAlignment = .right
            self.txtPassword.textAlignment = .right
        }
        else
        {
            self.txtEmail.textAlignment = .left
            self.txtPassword.textAlignment = .left
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    @IBAction func btnSignIn(_ sender: UIButton)
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
            else if (txtPassword.text?.count)! == 0
            {
                self.showOkAlert(title: "Error".localized, message: "Please enter your password".localized)
            }
            else
            {
                self.showIndicator()
                var deviceToken = MyTools.tools.getDeviceToken()
                if deviceToken == nil 
                {
                    deviceToken = InstanceID.instanceID().token()!
                }
                MyApi.api.PostLoginUser(email: txtEmail.text!, password: txtPassword.text!, token: deviceToken!)
                { (response, err) in
                    if((err) == nil)
                    {
                        if let JSON = response.result.value as? NSDictionary
                        {
                            let  status = JSON["status"] as? Int
                            if (status == 1)
                            {
                                print("success")
                                //go to tabbar depend on user role
                                let UserArray = JSON["items"] as? NSDictionary
                                let verifyStatus = UserArray?.value(forKey: "status") as! Int
                                self.hideIndicator()

                                if(verifyStatus == 1)
                                {
                                    //redirect to tabbar
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
                                    //redirect to activation view
                                    let vc : SAVerifySms = AppDelegate.storyboard.instanceVC()
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                            }
                            else
                            {
                                self.hideIndicator()
                                self.showOkAlert(title: "Error".localized, message: JSON["message"] as? String ?? "")
                            }
                        }
                        else{
                            self.hideIndicator()
                            self.showOkAlert(title: "Error".localized, message: "Invalid Password".localized)
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
            self.showOkAlert(title: "Error", message: "No Internet Connection")
        }
    }
}
