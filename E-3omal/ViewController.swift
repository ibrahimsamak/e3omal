//
//  ViewController.swift
//  E-3omal
//
//  Created by ibrahim M. samak on 7/4/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class ViewController: SuperView {
   
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.runTimedCode()
        }
    }

    @objc func runTimedCode()
    {
        let vc:SAAds = AppDelegate.storyboard.instanceVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

