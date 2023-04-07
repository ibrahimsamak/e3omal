//
//  Recent.swift
//  E-3omal
//
//  Created by ibrahim M. samak on 4/18/17.
//  Copyright © 2017 RamezAdnan. All rights reserved.
//


import UIKit
import Foundation
import Firebase

struct RecentMessage
{
    var Conv_Id : String
    var Conv_type : String
    var Last_Msg : String
    var Msg_Type   : String
    var Name_other : String
    var Reciver : String
    var Sender : String
    var Image_other : String
    var Timestamp : Int64
    
    init(Conv_Id:String, Conv_type:String, Last_Msg:String, Msg_Type: String, Name_other: String , Reciver: String , Sender :String , Timestamp :Int64 , Image_other:String)
    {
        self.Conv_Id = Conv_Id
        self.Conv_type = Conv_type
        self.Last_Msg = Last_Msg
        self.Msg_Type = Msg_Type
        self.Name_other = Name_other
        self.Reciver = Reciver
        self.Sender = Sender
        self.Image_other = Image_other
        
        self.Timestamp = Timestamp
    }
    
    
    init(snapshot: DataSnapshot)
    {
        let valueData = snapshot.value as! NSDictionary
        Conv_Id = valueData.value(forKey: "Conv_Id") as! String
        Conv_type = valueData.value(forKey: "Conv_type") as! String
        Last_Msg = valueData.value(forKey: "Last_Msg") as! String
        Msg_Type = valueData.value(forKey: "Msg_Type") as! String
        Name_other = valueData.value(forKey: "Name_other") as! String
        Reciver = valueData.value(forKey: "Reciver") as! String
        Sender = valueData.value(forKey: "Sender") as! String
        Image_other = valueData.value(forKey: "Image_other") as! String
        Timestamp = valueData.value(forKey: "Timestamp") as! Int64
    }
    
    func toAnyObject() -> Any
    {
        return [
                "Conv_Id":self.Conv_Id,
                "Conv_type" :self.Conv_type ,
                "Last_Msg" : self.Last_Msg,
                "Msg_Type":self.Msg_Type,
                "Name_other":self.Name_other,
                "Reciver":self.Reciver,
                "Sender" :self.Sender,
                "Image_other" :self.Image_other,
                "Timestamp" :self.Timestamp
                ]
    }
}

