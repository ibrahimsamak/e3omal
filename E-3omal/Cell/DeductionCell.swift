//
//  DeductionCell.swift
//  E-3omal
//
//  Created by ibrahim M. samak on 7/10/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class DeductionCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var contentviewCell: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.contentviewCell.layer.cornerRadius = 5
        self.contentviewCell.layer.masksToBounds = true
        
        if(Language.currentLanguage().contains("ar")){
            lblTime.textAlignment = .right
            lblDate.textAlignment = .right
            lblAmount.textAlignment = .right
            lblTitle.textAlignment = .right
        }
        else{
            lblDate.textAlignment = .left
            lblTime.textAlignment = .left
            lblAmount.textAlignment = .left
            lblTitle.textAlignment = .left
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
