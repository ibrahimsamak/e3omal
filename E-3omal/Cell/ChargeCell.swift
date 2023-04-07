//
//  ChargeCell.swift
//  E-3omal
//
//  Created by ibrahim M. samak on 7/10/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class ChargeCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var NewBalance: UILabel!
    @IBOutlet weak var oldBalance: UILabel!
    @IBOutlet weak var lblTitle1: UILabel!
    @IBOutlet weak var lblTitle2: UILabel!
    @IBOutlet weak var lblTitle3: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if(Language.currentLanguage().contains("ar")){
            lblDate.textAlignment = .right
            lblTime.textAlignment = .right
            lblAmount.textAlignment = .right
            NewBalance.textAlignment = .right
            oldBalance.textAlignment = .right
            lblTitle1.textAlignment = .right
            lblTitle2.textAlignment = .right
            lblTitle3.textAlignment = .right
        }
        else{
            lblDate.textAlignment = .left
            lblTime.textAlignment = .left
            lblAmount.textAlignment = .left
            NewBalance.textAlignment = .left
            oldBalance.textAlignment = .left
            
            lblTitle1.textAlignment = .left
            lblTitle2.textAlignment = .left
            lblTitle3.textAlignment = .left
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
