//
//  ChatsTableVC.swift
//  help
//
//  Created by Mostafa on 3/25/17.
//  Copyright © 2017 com. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import SDWebImage

class ChatsTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var dataAndConnectionImage: UIImageView!
    fileprivate var chatFunctions = ChatFunctions()
//    private var RefHandle: DatabaseHandle?
    var allRecent : [RecentMessage] = []
    var prevArray : NSMutableArray = []
    var btn = UIButton(type: UIButtonType.custom) as UIButton
    var imagebg = UIImageView()
    let screenSize = UIScreen.main.bounds
    
    fileprivate var userId :String = ""
    
    var reciverUid = ""
    var reciverName = ""
    var reciverImage = ""
    
    var dataBaseRef: DatabaseReference! {
        return Database.database().reference()
    }
    
    var storageRef: Storage {
        return Storage.storage()
    }
    
//    deinit
//    {
//        if let Handler = RefHandle
//        {
//            dataBaseRef.removeObserver(withHandle: Handler)
//        }
//    }
//
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.setupNavigationBarwithBack()
        self.navigationItem.title = "ALL MESSAGES"
        self.tableView.register(UINib(nibName: "ChatsCell", bundle: nil), forCellReuseIdentifier: "ChatsCell")

        tableView.tableFooterView = UIView(frame: .zero)
        userId = MyTools.tools.getMyId()
        
        //dataAndConnectionImage.isHidden = true
        if MyTools.tools.connectedToNetwork()
        {
//            prevArray.removeAllObjects()
//            allRecent.removeAllObjects()
            //self.getRecents()
        }
        else
        {
            //self.dataAndConnectionImage.isHidden = false
            //dataAndConnectionImage.image = UIImage(named: "noInternet-icon")
            //self.allRecent.removeAllObjects()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let ns = UserDefaults.standard
        ns.removeObject(forKey: "notificationType")
        if MyTools.tools.connectedToNetwork()
        {
            prevArray.removeAllObjects()
            allRecent.removeAll()
            self.getRecents()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
//        dataBaseRef.removeObserver(withHandle: RefHandle!)
//        prevArray.removeAllObjects()
//        allRecent.removeAllObjects()
    }
    
    //MARK: Recents
    func getRecents()
    {
        
        self.showIndicator()
        let usersRef = dataBaseRef.child("RecentMessage").child(MyTools.tools.getMyId())
        usersRef.observeSingleEvent(of: .value, with: { (snapshot) in
            var isMyChat = false
            let enumerator = snapshot.children
            
            for snapValue in enumerator
            {
                let snapshotValue = RecentMessage.init(snapshot: snapValue as! DataSnapshot)
                if snapshotValue.Reciver == self.userId || snapshotValue.Sender == self.userId
                {
                    isMyChat = true
                    self.allRecent.append(snapshotValue)
                    self.tableView.reloadData()
                }
                else
                {
                    isMyChat = false
                }
                self.hideIndicator()
                self.allRecent.sort {$0.Timestamp > $1.Timestamp}
                self.tableView.reloadData()
            }
            
        })
//        RefHandle =  usersRef.observe(.value, with: { (snapshot) in
//            var isMyChat = false
//            let enumerator = snapshot.children
//
//            for snapValue in enumerator
//            {
//                let snapshotValue = RecentMessage.init(snapshot: snapValue as! DataSnapshot)
//                if snapshotValue.Reciver == self.userId || snapshotValue.Sender == self.userId
//                {
//                    isMyChat = true
//                    self.allRecent.add(snapshotValue)
//                    self.tableView.reloadData()
//                }
//                else
//                {
//                    isMyChat = false
//                }
//
//            self.tableView.reloadData()
//            }})
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return allRecent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatsCell", for: indexPath) as! ChatsCell
        
        let recent = allRecent[indexPath.row] as! RecentMessage
        var userdata = MyTools.tools.getMyId()

        cell.userImageView.backgroundColor = UIColor.lightGray
        
        if recent.Image_other != ""
        {
            let url = URL(string:recent.Image_other)
            cell.userImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "Avatar"), options: .refreshCached, completed: nil)
        }
        cell.txtUserName.text = recent.Name_other
        cell.txtLastMessage.text = recent.Last_Msg
        
//        let dateAgo = recent.Timestamp
//        let date = Date(timeIntervalSince1970: TimeInterval(dateAgo))
//        cell.txtMessageTime.text = MyTools.tools.GetDateAgo(dt_date: date)
       
        let dateString = MyTools.tools.convertDateToString(NSDate(timeIntervalSince1970: TimeInterval(recent.Timestamp)) as Date)
        
        cell.txtMessageTime.text =  dateString
        cell.userImageView.setRounded()
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
//    @objc func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
//    {
//        ret
//    }
    
    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//
//        // 5
//        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete" , handler: { (action:UITableViewRowAction!, indexPath:IndexPath!) -> Void in
//            // 6
//            let rectNode = (self.allRecent[indexPath.row] as! RecentMessage).Conv_Id
//
//            let messageQuery = self.dataBaseRef.child(NSConstant.MyConstant.chatRoomsNode).child(rectNode).child(NSConstant.MyConstant.messages+"_"+MyTools.tools.getMyId())
//            messageQuery.removeValue()
//            self.allRecent.removeObject(at: indexPath.row)
//            self.tableView.reloadData()
//
//        })
//        deleteAction.backgroundColor = UIColor.red
//
//
//        // 7
//        return [deleteAction]
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: false)

        if(MyTools.tools.connectedToNetwork())
        {
            let info = allRecent[indexPath.row] as! RecentMessage
            let userId =  MyTools.tools.getMyId()
            let recent = allRecent[indexPath.row] as! RecentMessage

            if userId == recent.Sender
            {
                chatFunctions.startChat(userId, user2: recent.Reciver)
                self.reciverImage  = info.Image_other
                self.reciverUid = info.Reciver
                self.reciverName = info.Name_other
                performSegue(withIdentifier: "showChat", sender: self)
            }
            else
            {
                chatFunctions.startChat(userId, user2: recent.Sender)
                self.reciverImage  = info.Image_other
                self.reciverUid = info.Sender
                self.reciverName = info.Name_other
                performSegue(withIdentifier: "showChat", sender: self)
            }
        }
        else
        {
            self.showOkAlert(title: "Error", message: "No Internet Connection")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "showChat"
        {
            let chatViewController = segue.destination as! ChatViewController
            chatViewController.senderId = userId
            let displayName = MyTools.tools.getMyKey("name")
            chatViewController.senderDisplayName = displayName
            chatViewController.chatRoomId = chatFunctions.chatRoom_id
            chatViewController.reciverUid = self.reciverUid
            chatViewController.reciverName = self.reciverName
            chatViewController.reciverImage = self.reciverImage
        }
    }
}



