//
//  catCell.swift
//  E-3omal
//
//  Created by ibrahim M. samak on 9/1/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class catCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib()
    {
        super.awakeFromNib()
       
//        if (Language.currentLanguage() == "ar"){
//            img.transform = CGAffineTransform(scaleX: -1, y: 1)
//        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
