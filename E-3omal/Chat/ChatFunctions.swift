//
//  ChatFunctions.swift
//  E-3omal
//
//  Created by ibrahim M. samak on 4/18/17.
//  Copyright © 2017 RamezAdnan. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct ChatFunctions{
    
    var chatRoom_id =  String()
//    var reciverUid =  String()
//    var reciverName =  String()
//    var reciverImage =  String()
    
    fileprivate var databaseRef: DatabaseReference! {
        return Database.database().reference()
    }
    
    mutating func startChat(_ user1: String, user2: String){
        
        let userId1 = user1
        let userId2 = user2
        var chatRoomId = ""
        
        let comparison = userId1.compare(userId2).rawValue
        
        if comparison < 0
        {
            chatRoomId = userId1 + "_" + userId2
        }
        else
        {
            chatRoomId = userId2 + "_" + userId1
        }
        
        
//        self.reciverUid   = user2.UserId
//        self.reciverImage = user2.UserImage
//        self.reciverName  = user2.FullName
        self.chatRoom_id  = chatRoomId
    }
    
    fileprivate func createChatRoomId(_ user1: String, user2: String, members:[String], chatRoomId: String)
    {
        let chatRoomRef = databaseRef.child("Conversation").queryOrdered(byChild: chatRoom_id).queryEqual(toValue: chatRoom_id)
        chatRoomRef.observe(.value, with: { (snapshot) in
            
            var createChatRoom = true
            
            if snapshot.exists()
            {
                for chatRoom in ((snapshot.value! as! [String: AnyObject]))
                {
                    if (chatRoom.value["groupId"] as! String) == self.chatRoom_id
                    {
                        createChatRoom = false
                    }
                }
            }
            
            if createChatRoom
            {
//                self.createNewChatRoomId(user1.FullName, other_Username: user2.FullName, userId: user1.UserId, other_UserId: user2.UserId, members: members, chatRoomId: self.chatRoom_id, lastMessage: "", userPhotoUrl: user1.UserImage, other_UserPhotoUrl: user2.UserImage,date:  NSNumber(integerLiteral: Int(Date().timeIntervalSinceNow)))
            }
        })
      
        //        { (error) in
        //
        //            DispatchQueue.main.async(execute: {
        //            })        }
        
        
    }
    
    
    fileprivate func createNewChatRoomId(_ username: String, other_Username: String,userId: String,other_UserId: String,members: [String],chatRoomId: String,lastMessage: String,userPhotoUrl: String,other_UserPhotoUrl: String, date: NSNumber)
    {
        //let newChatRoom = ChatRoom(username: username, other_Username: other_Username, userId: userId, other_UserId: other_UserId, members: members, chatRoomId: chatRoomId, lastMessage: lastMessage, userPhotoUrl: userPhotoUrl, other_UserPhotoUrl: other_UserPhotoUrl,date:date)
        
        //let chatRoomRef = databaseRef.child("chat_rooms").child(chatRoomId)
        //chatRoomRef.setValue(newChatRoom.toAnyObject())
        
    }
    
    
    
    
}
