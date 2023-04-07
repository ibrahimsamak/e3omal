//
//  CustomeView3.swift
//  E-3omal
//
//  Created by ibrahim M. samak on 7/9/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class CustomeView3: UIView {

    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = MyTools.tools.colorWithHexString("D0CFD6").cgColor
    }

}
