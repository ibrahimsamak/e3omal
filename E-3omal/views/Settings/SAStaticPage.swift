//
//  SAStaticPage.swift
//  E-3omal
//
//  Created by ibrahim M. samak on 7/11/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import Foundation

class SAStaticPage: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var PageType = ""
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.loadData(_pageType: self.PageType)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.setupNavigationBarwithBack()
    }
    
  
    func loadData(_pageType:String)
    {
        if(_pageType == "terms")
        {
            self.navigationItem.title =  "Terms of Use".localized
            
            if MyTools.tools.connectedToNetwork()
            {
                self.showIndicator()
                MyApi.api.GetTerms(){(response, err) in
                    if((err) == nil)
                    {
                        if let JSON = response.result.value as? NSDictionary
                        {
                            let status = JSON["status"] as? Bool
                            if (status == true)
                            {
                                let items = JSON["items"] as! NSDictionary
                                let content  =  items.value(forKey: "content") as! String
                                let htmlString:String! = content
                                self.webView.loadHTMLString(htmlString, baseURL: nil)
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
        else if (_pageType == "privacy")
        {
            self.navigationItem.title =  "Privacy Policy".localized

            if MyTools.tools.connectedToNetwork()
            {
                self.showIndicator()
                MyApi.api.GetPrivacy(){(response, err) in
                    if((err) == nil)
                    {
                        if let JSON = response.result.value as? NSDictionary
                        {
                            let status = JSON["status"] as? Bool
                            if (status == true)
                            {
                                let items = JSON["items"] as! NSDictionary
                                let content  =  items.value(forKey: "content") as! String
                                let htmlString:String! = content
                                self.webView.loadHTMLString(htmlString, baseURL: nil)
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
        else{
            self.navigationItem.title =  "About Us".localized

            if MyTools.tools.connectedToNetwork()
            {
                self.showIndicator()
                MyApi.api.GetAbout(){(response, err) in
                    if((err) == nil)
                    {
                        if let JSON = response.result.value as? NSDictionary
                        {
                            let status = JSON["status"] as? Bool
                            if (status == true)
                            {
                                let items = JSON["items"] as! NSDictionary
                                let content  =  items.value(forKey: "content") as! String
                                let htmlString:String! = content
                                self.webView.loadHTMLString(htmlString, baseURL: nil)
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
                        self.showOkAlert(title: "Error".localized.localized, message: "An Error occurred".localized)
                    }
                }
            }
            else
            {
                self.showOkAlert(title: "Error".localized, message: "No Internet Connection".localized)
            }
        }
    }
}
