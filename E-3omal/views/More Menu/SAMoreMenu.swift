//
//  SAMoreMenu.swift
//  E-3omal
//
//  Created by ibrahim M. samak on 7/10/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import SafariServices

class SAMoreMenu: UIViewController {

    @IBOutlet weak var WalletView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        if(MyTools.tools.getUserType() == "customer")
        {
            self.WalletView.isHidden = true
        }
    }
    
    @IBAction func btnClick(_ sender: UIButton)
    {
        if(sender.tag == 1)
        {
            let vc: SAContactUs = AppDelegate.storyboard.instanceVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if(sender.tag == 2)
        {
            let vc:SAStaticPage = AppDelegate.storyboard.instanceVC()
            vc.PageType = "about"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if(sender.tag == 3)
        {
            let vc:ChatsTableVC = AppDelegate.storyboard.instanceVC()
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        if(sender.tag == 4)
        {
            let vc:SAWallet = AppDelegate.storyboard.instanceVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnSocial(_ sender: UIButton)
    {
        if(sender.tag == 1)
        {
            //facebook
            let urlString = MyTools.tools.getConfigString("facebook")
            let url = URL(string: urlString)
            let vc = SFSafariViewController(url: url!)
            present(vc, animated: true, completion: nil) 
        }
        if(sender.tag == 2)
        {
            //twitter
            let urlString = MyTools.tools.getConfigString("twitter")
            let url = URL(string: urlString)
            let vc = SFSafariViewController(url: url!)
            present(vc, animated: true, completion: nil)
        }
        if(sender.tag == 3)
        {
            //google plus
            let urlString = MyTools.tools.getConfigString("instagram")
            let url = URL(string: urlString)
            let vc = SFSafariViewController(url: url!)
            present(vc, animated: true, completion: nil) 
        }
    }
    
    
    @IBAction func btnSite(_ sender: UIButton)
    {
        let urlString = "http://www.linekw.com"
        let url = URL(string: urlString)
        let vc = SFSafariViewController(url: url!)
        present(vc, animated: true, completion: nil)
    }
}
