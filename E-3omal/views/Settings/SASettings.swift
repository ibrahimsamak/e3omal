//
//  SASettings.swift
//  E-3omal
//
//  Created by ibrahim M. samak on 7/10/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import Firebase

class SASettings: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tbl: UITableView!
    var titles: [String] = ["Notifications".localized , "Terms and conditions".localized , "Terms & Conditions".localized , "Privacy Policy".localized , "Logout".localized]
   
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.tbl.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if(indexPath.row == 0)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! SettingsNotificationCell
            cell.lblTitle.text = titles[indexPath.row]
            cell.config()
            cell.CustomVC = self
            return cell
        }
        else if(indexPath.row == 1)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LangaugeCell
            if(Language.currentLanguage().contains("ar"))
            {
                cell.lblSwitch.curState = .R
            }
            else
            {
                cell.lblSwitch.curState = .L
            }
            cell.config()
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
         
            if(Language.currentLanguage().contains("ar")){
                  cell.textLabel?.textAlignment = .right
            }
            else{
                  cell.textLabel?.textAlignment = .left
            }
            cell.textLabel?.text = self.titles[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tbl.deselectRow(at: indexPath, animated: true)
        if(indexPath.row == 0)
        {
//            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
//                return
//            }
//            
//            if UIApplication.shared.canOpenURL(settingsUrl) {
//                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
//                    print("Settings opened: \(success)") // Prints true
//                })
//            }
        }
        if(indexPath.row == 1)
        {
            
        }
        if(indexPath.row == 2)
        {
            let vc:SAStaticPage = AppDelegate.storyboard.instanceVC()
            vc.PageType = "terms"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if(indexPath.row == 3)
        {
            let vc:SAStaticPage = AppDelegate.storyboard.instanceVC()
            vc.PageType = "privacy"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if(indexPath.row == 4)
        {
            self.showCustomAlert(okFlag: false, title: "Warning".localized, message: "Are you sure you want logout?".localized, okTitle: "Logout".localized, cancelTitle: "Cancel".localized)
            {(success) in
                if(success)
                {
                    self.logout()
                }
            }
        }
    }
    
    
    func logout()
    {
        if MyTools.tools.connectedToNetwork()
        {
            
            var deviceToken = MyTools.tools.getDeviceToken()
            if deviceToken == nil
            {
                deviceToken = InstanceID.instanceID().token()!
            }
            
            self.showIndicator()
            MyApi.api.Postlogout(token: deviceToken!)
            {(response, err) in
                if((err) == nil)
                {
                    if let JSON = response.result.value as? NSDictionary
                    {
                        let  status = JSON["status"] as? Int
                        if (status == 1)
                        {
                            let ns = UserDefaults.standard
                            ns.removeObject(forKey: "CurrentUser")
                            let vc : SignInRoot = AppDelegate.storyboard.instanceVC()
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
}
