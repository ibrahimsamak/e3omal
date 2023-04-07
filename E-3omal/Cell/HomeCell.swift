//
//  HomeCell.swift
//  E-3omal
//
//  Created by ibrahim M. samak on 7/9/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class HomeCell: UITableViewCell {

    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblBudget: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var statusIcon: UIImageView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var btnProviderProfile: UIButton!
    @IBOutlet weak var btnChangeStatus: UIButton!
    @IBOutlet weak var flipIcon: UIImageView!
    @IBOutlet weak var contentCellView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
      
        if(Language.currentLanguage().contains("ar")){
            lblStatus.textAlignment = .center
            lblBudget.textAlignment = .right
            lblLocation.textAlignment = .right
            lblCategory.textAlignment = .right
            lblTitle.textAlignment = .right
        }
        else{
            lblStatus.textAlignment = .center
            lblBudget.textAlignment = .left
            lblLocation.textAlignment = .left
            lblCategory.textAlignment = .left
            lblTitle.textAlignment = .left
        }
        
        self.contentCellView.layer.cornerRadius = 5
        self.contentCellView.layer.masksToBounds = true
        
        self.statusView.layer.cornerRadius = 5
        self.statusView.layer.masksToBounds = true
        self.statusView.layer.borderWidth = 1
        self.statusView.layer.borderColor = MyTools.tools.colorWithHexString("A9A8BB").cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
