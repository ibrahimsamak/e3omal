//
//  NotificationCell.swift
//  E-3omal
//
//  Created by ibrahim M. samak on 7/18/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var lblmsg: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()

        if(Language.currentLanguage().contains("ar")){
            lblmsg.textAlignment = .right
        }
        else{
            lblmsg.textAlignment = .left
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
