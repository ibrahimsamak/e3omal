//
//  NSConstant.swift
//  E-3omal
//
//  Created by ibrahim M. samak on 4/6/17.
//  Copyright © 2017 RamezAdnan. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

struct NSConstant
{
    struct MyConstant
    {
        static let stoagePath = Storage.storage().reference(forURL: "")
        static let DBRefrence = Database.database().reference()
        static let FCMLink = "https://fcm.googleapis.com/fcm/send"
        
        static let Authorization =
            ["Authorization":"key=AAAAwpIBNNI:APA91bHJXLp9k1Y4X4qyMK6RO0h-y0DYsO90JbgSmuHuY4UKz13MfePknCfwJMELK8zcACQRHW3hsuryVEbtny6wZhZiKSSCWTzgyRYmodXHiduJNATjlhqS7753mKPSDHZHCluhl029","Accept": "application/json"]
        
        
        //Recent Tree
        static let RecentNode = "RecentMessage"

        
        //chat rooms Tree
        static let chatRoomsNode = "Conversation"

        
        //loadDataNotification
        static let loadDataNotification = Notification.Name(rawValue: "loadDataNotification")
       
    }
}
