//
//  SettingsNotificationCell.swift
//  E-3omal
//
//  Created by ibrahim M. samak on 8/4/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import LabelSwitch

class SettingsNotificationCell: UITableViewCell , LabelSwitchDelegate{
    
    @IBOutlet weak var lblSwitch: LabelSwitch!
    @IBOutlet weak var lblTitle: UILabel!
    var CustomVC :UIViewController  = UIViewController()
    var status = 0
    
    func switchChangToState(_ state: SwitchState)
    {
        if (state == .R)
        {
            // off
            self.loadDate(0)
        }
        else
        {
            // on
            self.loadDate(1)
        }
    }
   
    override func awakeFromNib()
    {
        super.awakeFromNib()
        if(Language.currentLanguage().contains("ar"))
        {
            lblTitle.textAlignment = .right
        }
        else
        {
            lblTitle.textAlignment = .left
        }
    }
    
    func config()
    {
        self.lblSwitch.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func loadDate(_ status:Int)
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.CustomVC.showIndicator()
            MyApi.api.PostNotifications(notification_status: self.status)
            {(response, error) in
                if(response.result.value != nil)
                {
                    if let JSON = response.result.value as? NSDictionary
                    {
                        let status = JSON["status"] as? Int
                        if(status == 1)
                        {
                            self.CustomVC.hideIndicator()
                            self.CustomVC.showOkAlert(title: "Success".localized, message: JSON["message"] as? String ?? "")
                        }
                        else
                        {
                            self.CustomVC.hideIndicator()
                            self.CustomVC.showOkAlert(title: "Error".localized, message: JSON["message"] as? String ?? "")
                        }
                    }
                }
                else
                {
                    self.CustomVC.hideIndicator()
                    self.CustomVC.showOkAlert(title: "Error".localized, message: "An Error occurred".localized)
                }
            }
        }
        else
        {
            self.CustomVC.showOkAlert(title: "Error".localized, message: "No Internet Connection".localized)
        }
    }
}
