//
//  ChatViewController.swift
//  E-3omal
//
//  Created by ibrahim M. samak on 4/8/7.
//  Copyright © 207 Tareq Safia. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase
import FirebaseStorage
import FirebaseDatabase
import FirebaseMessaging
import MobileCoreServices
import AVKit
import AMPopTip

class ChatViewController: JSQMessagesViewController, UIImagePickerControllerDelegate  {
    
    var chatRoomId: String!
    var reciverUid: String!
    var reciverName: String!
    var reciverImage: String!
    var messages = [JSQMessage]()
    var pageSize = 20
    let preloadMargin = 5
    var lastLoadedPage = 0
    var insertCounter = 0
    var  popTip = PopTip()
    
    var  allMessagesId = [""]
    var messagesContent = [Conversation]()
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    
    var databaseRef: DatabaseReference! {
        return Database.database().reference()
    }
    
    var storageRef: Storage!{
        return Storage.storage()
    }
    
    var userIsTypingRef: DatabaseReference!
    var isReciverActive : Bool = false
    var reciverAvatar :UIImage? = UIImage(named:"Avatar")
    var senderAvatar :UIImage? = UIImage(named:"Avatar")
    
    fileprivate var localTyping: Bool = false
    fileprivate var count = 0
    private var isActiveHandle: DatabaseHandle?
    private var isTypingHandle: DatabaseHandle?
    
    deinit
    {
        if  isActiveHandle != nil
        {
            databaseRef.removeObserver(withHandle: isActiveHandle!)
        }
        if  isTypingHandle != nil
        {
            databaseRef.removeObserver(withHandle: isTypingHandle!)
        }
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(UpdateChat), name: NSNotification.Name("UpdateChat"), object: nil)

        
        showLoadEarlierMessagesHeader = false

        self.downloadAvatrImage(url: self.reciverImage)
        self.getMyAvatar()
        let factory = JSQMessagesBubbleImageFactory()
        incomingBubbleImageView = factory?.incomingMessagesBubbleImage(with: "5AA4C1".color)
        outgoingBubbleImageView = factory?.outgoingMessagesBubbleImage(with:"4E4A7F".color)
        
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize(width:36,height:36)
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize(width:36,height:36)

        let buttonWidth = CGFloat(40)
        let buttonHeight = inputToolbar.contentView.leftBarButtonContainerView.frame.size.height
        
        let customButton = UIButton(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight))
        customButton.setImage(UIImage(named: "sendbtn"), for: .normal)
        customButton.imageView?.contentMode = .scaleAspectFit
        
        if(Language.currentLanguage().contains("ar")){
            customButton.imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
            inputToolbar.contentView.textView.placeHolder = "اكتب هنا"
        }
        else{
            inputToolbar.contentView.textView.placeHolder = "write here"
        }
        
        inputToolbar.contentView.rightBarButtonItemWidth = buttonWidth
        inputToolbar.contentView.rightBarButtonItem = customButton
        self.fetchMessages()
    }
    
    
    @objc func UpdateChat(){
        self.fetchMessages()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.inputToolbar.contentView.leftBarButtonItem.isHidden = true
        self.inputToolbar.contentView.backgroundColor = UIColor.white
        self.inputToolbar.contentView.textView.layer.borderWidth = 0
        var frame : CGRect = self.inputToolbar.contentView.textView.frame
        frame.origin.x = 0
        self.inputToolbar.contentView.textView.frame = frame
        
        self.title = reciverName
       
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
    }

    
    func fetchMessages()
    {
        self.messages.removeAll()
        let messageQuery = databaseRef.child(NSConstant.MyConstant.chatRoomsNode).child(chatRoomId).queryOrdered(byChild: "ID")
        messageQuery.observeSingleEvent(of: .value){ (snapshot) in
//            let snapshotValue = snapshot.value as! [String: AnyObject]
            let enumerator = snapshot.children
            
            for snapValue in enumerator
            {
                let snap =  snapValue as! DataSnapshot
                let valueData = snap.value as! NSDictionary

                let senderId = valueData.value(forKey: "From_Id") as? String ?? ""
                let text = valueData.value(forKey: "Content") as? String ?? ""
                let displayName = MyTools.tools.getMyKey("name")
                let mediaType = valueData.value(forKey: "Msg_Type") as? String ?? ""
                
                switch mediaType
                {
                case "text":
                    self.messages.append(JSQMessage(senderId: senderId, displayName: displayName, text: text))
                default: break
                }
            }
            self.finishReceivingMessage()
        };
    }
    
    override func textViewDidChange(_ textView: UITextView)
    {
        super.textViewDidChange(textView)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!)
    {
        
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!)
    {
        if(MyTools.tools.connectedToNetwork())
        {
            let time = Int64(Date().timeIntervalSince1970)
            let messageRefSender = databaseRef.child(NSConstant.MyConstant.chatRoomsNode).child(self.chatRoomId).child(String(time))
            
            let  message = Conversation(Content: text, Conv_Id: self.chatRoomId, From_Id: MyTools.tools.getMyId(), Msg_Id: time , Msg_Type: "text", To_Id: self.reciverUid, To_Name: self.reciverName, Timestamp: time,ID:self.messages.count+1)
            
            
            //recent me
            let recent = RecentMessage(Conv_Id: self.chatRoomId, Conv_type: "Single", Last_Msg: text, Msg_Type: "text", Name_other: self.reciverName, Reciver: self.reciverUid, Sender: MyTools.tools.getMyId(), Timestamp: time,Image_other:self.reciverImage)
            
            //recent other
            let recentOther = RecentMessage(Conv_Id: self.chatRoomId, Conv_type: "Single", Last_Msg: text, Msg_Type: "text", Name_other: MyTools.tools.getMyKey("name"), Reciver: MyTools.tools.getMyId(), Sender: self.reciverUid, Timestamp: time, Image_other:MyTools.tools.getMyKey("profile_image"))
            
            
            
            messageRefSender.setValue(message.toAnyObject()) { (error, ref) in
                if error == nil
                {
                    
                    JSQSystemSoundPlayer.jsq_playMessageSentSound()
                    
                    //recent for me
                    self.databaseRef.child(NSConstant.MyConstant.RecentNode).child(MyTools.tools.getMyId()).child(self.chatRoomId).setValue(recent.toAnyObject())
                    
                    
                    //recent for other
                self.databaseRef.child(NSConstant.MyConstant.RecentNode).child(self.reciverUid).child(self.chatRoomId).setValue(recentOther.toAnyObject())
                    
                    
                    self.fetchMessages()
                    self.finishSendingMessage()
                    self.collectionView.reloadData()
                    self.sendNotification(self.reciverUid,text)
                    
                }
            }
        }
        else
        {
            self.showOkAlert(title: "Error", message: "No Internet Connection")
        }
    }
    
    func sendNotification(_ userid:String , _ msg:String){
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.PostSendNotification(customer_id: userid, message: msg)
            {(response, err) in
                if((err) == nil)
                {
                    if let JSON = response.result.value as? NSDictionary
                    {
                        let  status = JSON["status"] as? Int
                        if (status == 1)
                        {
                            self.hideIndicator()

                        }
                        else
                        {
                            self.hideIndicator()
                            self.showOkAlert(title: "Error".localized, message: JSON["message"] as? String ?? "")
                        }
                    }
                }
                else
                {
                    self.hideIndicator()
                    self.showOkAlert(title: "Error".localized, message: "An Error occurred".localized)
                }
            }
        }
        else
        {
            self.showOkAlert(title: "Error".localized, message: "No Internet Connection".localized)
        }
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        
        let alertController = UIAlertController(title: "Medias", message: "Choose your media type", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        
        let imageAction = UIAlertAction(title: "Image", style: UIAlertActionStyle.default) { (action) in
            self.getMedia(kUTTypeImage)
            
        }
        
        let videoAction = UIAlertAction(title: "Video", style: UIAlertActionStyle.default) { (action) in
            self.getMedia(kUTTypeMovie)
            
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        alertController.addAction(imageAction)
        alertController.addAction(videoAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let picture = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            self.saveMediaMessage(withImage: picture, withVideo: nil)
        }
            
        else if let videoUrl = info[UIImagePickerControllerMediaURL] as? URL
        {
            self.saveMediaMessage(withImage: nil, withVideo: videoUrl)
        }
        
        self.dismiss(animated: true)
        {
            JSQSystemSoundPlayer.jsq_playMessageSentSound()
            self.finishSendingMessage()
        }
    }
    
    
    fileprivate func saveMediaMessage(withImage image: UIImage?, withVideo: URL?)
    {
    
    }
    
    
    fileprivate func getMedia(_ mediaType: CFString)
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePicker.isEditing = true
        
        if mediaType == kUTTypeImage
        {
            imagePicker.mediaTypes = [mediaType as String]
            
        }
        else if mediaType == kUTTypeMovie
        {
            imagePicker.mediaTypes = [mediaType as String]
        }
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        if message.senderId == senderId
        {
            return outgoingBubbleImageView
        }
        else
        {
            return incomingBubbleImageView
        }
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData!
    {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource!
    {
        let message = messages[indexPath.item]
        if message.senderId == senderId
        {
            return JSQMessagesAvatarImageFactory.avatarImage(with: senderAvatar, diameter: 18)
        }
        else
        {
            return JSQMessagesAvatarImageFactory.avatarImage(with: reciverAvatar, diameter: 18)
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAt indexPath: IndexPath!) -> NSAttributedString!
    {
        if (indexPath.item % 5 == 0)
        {
            let message = self.messages[indexPath.item]
            
            return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
        }
        
        return nil
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.item]
        if !message.isMediaMessage
        {
            if message.senderId == senderId
            {
                cell.textView.textColor = UIColor.white
            }
            else
            {
                cell.textView.textColor = UIColor.black
            }
        }
        return cell
    }
    
    func downloadAvatrImage(url: String)
    {
        DispatchQueue.global(qos: .background).async {
            do
            {
                let dataImg = try Data.init(contentsOf: URL.init(string:url)!)
                DispatchQueue.main.async {
                    let image: UIImage = UIImage(data: dataImg)!
                    self.reciverAvatar = image
                    self.collectionView.reloadData()
                }
            }
            catch {
                // error
            }
        }
        
    }
    
    func downloadAvatrImageSender(url: String)
    {
        
        DispatchQueue.global(qos: .background).async {
            do
            {
                let dataImg = try Data.init(contentsOf: URL.init(string:url)!)
                DispatchQueue.main.async {
                    let image: UIImage = UIImage(data: dataImg)!
                    self.senderAvatar = image
                    self.collectionView.reloadData()
                }
            }
            catch {
                // error
            }
        }
    }
    
    func getMyAvatar()
    {
        let UserProfile = MyTools.tools.getMyKey("profile_image")
        self.downloadAvatrImageSender(url:(UserProfile))
    }
}
