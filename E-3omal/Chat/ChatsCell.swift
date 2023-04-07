//
//  ChatsCell.swift
//  E-3omal
//
//  Created by ibrahim M. samak on 6/13/17.
//  Copyright © 2017 ibrahim M. samak. All rights reserved.
//

import UIKit
class chats
{
    var senderName: String
    var message: String
    var senderImage: String
    var time: String
    
    init(senderName: String, message:String, senderImage:String, time:String) {
        
        self.senderName = senderName
        self.message = message
        self.senderImage = senderImage
        self.time = time
        
    }
    
}


class ChatsCell: UITableViewCell
{
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var txtUserName: UILabel!
    @IBOutlet weak var txtLastMessage: UILabel!
    @IBOutlet weak var txtMessageTime: UILabel!
    @IBOutlet weak var txtSeenCounter: UILabel!
    @IBOutlet weak var counterContainer: UIView!
    
    
    override func draw(_ rect: CGRect)
    {
        
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        if(Language.currentLanguage().contains("ar")){
            self.txtUserName.textAlignment = .right
            self.txtLastMessage.textAlignment = .right
            self.txtMessageTime.textAlignment = .center
        }
        else{
            self.txtUserName.textAlignment = .left
            self.txtLastMessage.textAlignment = .left
            self.txtMessageTime.textAlignment = .center
        }
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
}
