//
//  ChatRoot.swift
//  E-3omal
//
//  Created by ibrahim M. samak on 9/30/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class ChatRoot: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 10.0, *)
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.mainRootNav = self
        }
    }
}
