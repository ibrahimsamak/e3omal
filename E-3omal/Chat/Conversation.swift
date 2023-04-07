//
//  Message.swift
//  E-3omal
//
//  Created by ibrahim M. samak on 4/18/17.
//  Copyright © 2017 RamezAdnan. All rights reserved.
//


import Foundation
import FirebaseDatabase

struct Conversation
{
    var Content: String
    var Conv_Id: String
    var From_Id: String
    var Msg_Id: Int64
    var Timestamp: Int64
    var Msg_Type: String!
    var To_Id: String!
    var To_Name: String!
    var ID: Int!

    
    init(snapshot: DataSnapshot)
    {
        let snapshotValue = snapshot.value as! [String: AnyObject]

        Content = snapshotValue["Content"] as! String
        Conv_Id = snapshotValue["Conv_Id"] as! String
        From_Id = snapshotValue["From_Id"] as! String
        Msg_Id = snapshotValue["Msg_Id"] as! Int64
        Msg_Type = snapshotValue["Msg_Type"] as! String
        To_Id = snapshotValue["To_Id"] as! String
        To_Name = snapshotValue["To_Name"] as! String
        Timestamp = snapshotValue["timestamp"] as! Int64
        ID = snapshotValue["ID"] as! Int
    }
    
    
    init(Content: String ,
         Conv_Id: String,
         From_Id: String,
         Msg_Id: Int64,
         Msg_Type: String,
         To_Id: String,
         To_Name: String,
         Timestamp: Int64,ID: Int)
        
    {
        self.Content = Content
        self.Conv_Id = Conv_Id
        self.From_Id = From_Id
        self.Msg_Id = Msg_Id
        self.Msg_Type = Msg_Type
        self.To_Id = To_Id
        self.To_Name = To_Name
        self.Timestamp = Timestamp
        self.ID = ID
    }
    
    
    func toAnyObject() -> Any
    {
        return ["Content":self.Content,
                "Conv_Id":self.Conv_Id,
                "From_Id":self.From_Id,
                "Msg_Id":self.Msg_Id,
                "To_Id":self.To_Id,
                "To_Name":self.To_Name,
                "Msg_Type":self.Msg_Type,
                "timestamp":self.Timestamp,
                "ID":self.ID]
    }
}
