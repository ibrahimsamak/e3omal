//
//  LangaugeCell.swift
//  E-3omal
//
//  Created by ibrahim M. samak on 7/18/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import LabelSwitch

class LangaugeCell: UITableViewCell,LabelSwitchDelegate {
    
    func switchChangToState(_ state: SwitchState) {
        if (state == .R)
        {
            //Arabic
            Language.setAppLanguage(lang: "ar")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            self.rootnavigationController()
            print(Language.currentLanguage())
        }
        else
        {
            //Engilsh
            Language.setAppLanguage(lang: "en-US")
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            self.rootnavigationController()
            print(Language.currentLanguage())
        }
    }
    
    
    func rootnavigationController()
    {
        guard let window = UIApplication.shared.keyWindow else { return }
        let vc : SAMainTabbar = AppDelegate.storyboard.instanceVC()
        window.rootViewController = vc
    }
    
    @IBOutlet weak var lblSwitch: LabelSwitch!
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if(Language.currentLanguage().contains("ar"))
        {
         lblTitle.textAlignment = .right
        }
        else{
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
    
}
