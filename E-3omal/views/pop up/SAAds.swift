//
//  SAAds.swift
//  E-3omal
//
//  Created by ibrahim M. samak on 7/11/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import SDWebImage

class SAAds: UIViewController {
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var btn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.btn.isEnabled = false
        if ((UserDefaults.standard.value(forKey: "notificationType")) != nil)
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let val = UserDefaults.standard.value(forKey: "notificationType") as? String
     
            if(val == "3")
            {
                let vcChat : ChatsTableVC = AppDelegate.storyboard.instanceVC()
                let vc : SAMainTabbar = AppDelegate.storyboard.instanceVC()
                vc.selectedIndex = 4

                appDelegate.window?.rootViewController = vc
                appDelegate.window?.makeKeyAndVisible()
                appDelegate.mainRootNav?.pushViewController(vcChat, animated: true)
            }
            else {
                let vc : SAMainTabbar = AppDelegate.storyboard.instanceVC()
                vc.selectedIndex = 2
                
                let appDelegate = UIApplication.shared.delegate
                appDelegate?.window??.rootViewController = vc
                appDelegate?.window??.makeKeyAndVisible()
            }
        }
        else{
            self.navigationController?.isNavigationBarHidden = true
            self.loadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3)
            {
                self.btn.isEnabled = true
                self.runTimedCode()
            }
        }
    }
    
    @objc func runTimedCode()
    {
        if ((UserDefaults.standard.object(forKey: "CurrentUser")) != nil)
        {
            let vc : SAMainTabbar = AppDelegate.storyboard.instanceVC()
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = vc
            appDelegate?.window??.makeKeyAndVisible()
        }
        else
        {
            let vc:SALogin = AppDelegate.storyboard.instanceVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnClose(_ sender: UIButton)
    {
        if ((UserDefaults.standard.object(forKey: "CurrentUser")) != nil)
        {
            let vc : SAMainTabbar = AppDelegate.storyboard.instanceVC()
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = vc
            appDelegate?.window??.makeKeyAndVisible()
        }
        else
        {
            let vc:SALogin = AppDelegate.storyboard.instanceVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func loadData()
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.GetAds(){(response, err) in
                if((err) == nil)
                {
                    if let JSON = response.result.value as? NSDictionary
                    {
                        let status = JSON["status"] as? Bool
                        if (status == true)
                        {
                            let items = JSON["items"] as! NSDictionary
                            let img  =  items.value(forKey: "image") as! String
                            self.img.sd_setImage(with: URL(string: img)!, placeholderImage: UIImage(named: "10000-2")!, options: SDWebImageOptions.refreshCached)
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

extension SAAds : MIBlurPopupDelegate {
    
    var popupView: UIView {
        return self.view
    }
    
    var blurEffectStyle: UIBlurEffectStyle {
        return .dark
    }
    
    var initialScaleAmmount: CGFloat {
        return 3
    }
    
    var animationDuration: TimeInterval {
        return 0.5
    }
}
