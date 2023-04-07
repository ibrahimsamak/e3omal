//
//  SAEditProfileHandyman.swift
//  E-3omal
//
//  Created by ibrahim M. samak on 7/19/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import AssetsLibrary
import Photos
import MobileCoreServices
import SDWebImage
import Firebase
import BIZPopupView

class SAEditProfileHandyman: UIViewController , CategoryProtocol,
UICollectionViewDelegate , UICollectionViewDelegateFlowLayout ,  UICollectionViewDataSource ,UIActionSheetDelegate ,UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    
    func sendCategory(CateogryNameArr: [String], CategoryArr: [Int])
    {
        self.lblType.text = ""
        self.selecetedarr = CategoryArr
        self.selecetedNamearr = CateogryNameArr
        print(self.selecetedarr)
        print(self.selecetedNamearr)
        
        for index in 0..<self.selecetedNamearr.count
        {
            self.lblType.text! += self.selecetedNamearr[index] as! String+", "
        }
        
        let index2 = self.lblType.text?.index((self.lblType.text?.startIndex)!, offsetBy: (self.lblType.text?.characters.count)!-2)
        self.lblType.text =  self.lblType.text?.substring(to: index2!)
    }
    
    
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var txtCivil: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var txtNAme: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var col: UICollectionView!
    @IBOutlet weak var lblvideoName: UILabel!
    @IBOutlet weak var imgCamera: UIImageView!
    @IBOutlet weak var viewSwitch: CustomeView2!
    @IBOutlet weak var materialSwitch: UISwitch!
    @IBOutlet weak var videobgImage: UIImageView!
    @IBOutlet weak var playVideo: UIImageView!
   
    var selecetedarr = [Int]()
    var selecetedNamearr = [String]()
    var imageArray : [UIImage] = []
    var newImageArray : [UIImage] = []
    var is24 = 1
    var isChangeImage = false
    var entries : NSDictionary!
    var isProfileImage = false
    var isVideo = false
    var videoData : NSData = NSData()
    var videoName = ""
    var videoUrl = ""
    var TImages : NSArray = []

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setupNavigationBarwithBack()
        self.navigationItem.title = "Edit Profile".localized
        
        if(MyTools.tools.getUserType() != "handyman")
        {
            self.txtNAme.placeholder = "Company Name"
            self.viewSwitch.isHidden = true
        }
        
        
        if(Language.currentLanguage().contains("ar"))
        {
            self.lblType.textAlignment = .right
            self.lblvideoName.textAlignment = .right
            self.txtEmail.textAlignment = .right
            self.txtNAme.textAlignment = .right
            self.txtCivil.textAlignment = .right
            self.txtPhone.textAlignment = .right
        }
        else
        {
            self.lblType.textAlignment = .left
            self.lblvideoName.textAlignment = .left
            self.txtEmail.textAlignment = .left
            self.txtNAme.textAlignment = .left
            self.txtCivil.textAlignment = .left
            self.txtPhone.textAlignment = .left
        }

        self.loadData()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnChooseType(_ sender: UIButton)
    {
        let vc:SACategories = AppDelegate.storyboard.instanceVC()
                if(MyTools.tools.getUserType() == "handyman"){
                    vc.isContractor = false
                }
                if(MyTools.tools.getUserType() == "contractor"){
                    vc.isContractor = true
                }
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func switchCange(_ sender: UISwitch)
    {
        if sender.isOn{
            self.is24 = 1
        }
        else{
            self.is24 = 0
        }
        print(self.is24)
    }
    
    @IBAction func btnUpload(_ sender: UIButton)
    {
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title:"Images".localized, message: "Please select the image source".localized, preferredStyle: .actionSheet)
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel".localized, style: .cancel) { action -> Void in
            print("الغاء")
            self.isProfileImage = false
        }
        let saveActionButton: UIAlertAction = UIAlertAction(title: "Photo Library".localized, style: .default)
        { action -> Void in
            //Todo Upload image from Library
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = .photoLibrary
            self.isProfileImage = true
            self.isVideo = false
            self.present(picker, animated: true, completion: nil)
            
            print("مكتبة الصورة")
        }
        let deleteActionButton: UIAlertAction = UIAlertAction(title: "Camera".localized, style: .default)
        { action -> Void in
            //ToDo Upload image From Camera
            let picker = UIImagePickerController()
            picker.delegate = self
            self.isVideo = false
            picker.allowsEditing = true
            picker.sourceType = .camera
            self.isProfileImage = true
            self.present(picker, animated: true, completion: nil)
            
            print("Camera")
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        actionSheetControllerIOS8.addAction(saveActionButton)
        actionSheetControllerIOS8.addAction(deleteActionButton)
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad )
        {
            if let currentPopoverpresentioncontroller = actionSheetControllerIOS8.popoverPresentationController {
                actionSheetControllerIOS8.popoverPresentationController?.sourceView = self.view
                actionSheetControllerIOS8.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                actionSheetControllerIOS8.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
                
                self.present(actionSheetControllerIOS8, animated: true, completion: nil)
            }
        }
        else
        {
            self.present(actionSheetControllerIOS8, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnSignUp(_ sender: UIButton)
    {
        if MyTools.tools.connectedToNetwork()
        {
            if txtNAme.text?.count == 0
            {
                self.showOkAlert(title: "Error".localized, message: "Please enter your name".localized)
            }
            else if txtPhone.text?.count == 0{
                self.showOkAlert(title: "Error".localized, message: "Please enter your phone number".localized)
            }
            else if txtEmail.text?.count == 0{
                self.showOkAlert(title: "Error".localized, message: "Please enter your email address".localized)
            }
            else if !MyTools.tools.validateEmail(candidate: txtEmail.text!){
                self.showOkAlert(title: "Error".localized, message: "Please enter valid email address".localized)
            }
            else if  self.selecetedarr.count == 0{
                self.showOkAlert(title: "Error".localized, message: "Please select one type at least".localized)
            }
            else{
                let image = UIImageJPEGRepresentation(self.img.image!, 0.8) as? Data
                self.showIndicator()
                MyApi.api.PostEditUser(name: txtNAme.text!, email: txtEmail.text!, mobile: txtPhone.text!, image: image!, civil_id: txtCivil.text!, images: self.newImageArray, is_24: String(self.is24), video: self.videoData as Data, company_name:  txtNAme.text!, category_id: self.selecetedarr)
                { (response, error) in
                    if(response.result.value != nil)
                    {
                        if let JSON = response.result.value as? NSDictionary
                        {
                            let status = JSON["status"] as? Int
                            if(status == 1)
                            {
                                self.hideIndicator()
                                self.showOkAlertWithComp(title: "Success".localized, message:  JSON["message"] as? String ?? "", completion: { (Success) in
                                    if(Success){
                                        
                                        let UserArray = JSON["items"] as? NSDictionary
                                        
                                        let ns = UserDefaults.standard
                                        let CurrentUser:NSDictionary =
                                            [
                                                "email":UserArray?.value(forKey: "email") as! String ,
                                                "id":UserArray?.value(forKey: "id") as! Int,
                                                "name":UserArray?.value(forKey: "name") as! String ,
                                                "profile_image": UserArray?.value(forKey:
                                                "profile_image") as? String ?? ""  ,
                                                "mobile":UserArray?.value(forKey: "mobile") as! String ,
                                                "access_token":UserArray?.value(forKey: "access_token") as! String,
                                                "type": UserArray?.value(forKey: "type") as! String
                                            ]
                                        
                                        ns.setValue(CurrentUser, forKey: "CurrentUser")
                                        ns.synchronize()
                                        
                                        self.navigationController?.pop(animated: true)
                                    }
                                })
                            }
                            else
                            {
                                self.showOkAlert(title: "Error".localized, message: JSON["message"] as? String ?? "")
                            }
                            self.hideIndicator()
                        }
                    }
                    else
                    {
                        self.hideIndicator()
                        self.showOkAlert(title: "Error".localized, message: "An Error occurred".localized)
                    }
                }
            }
        }
        else{
            self.showOkAlert(title: "Error".localized, message: "No Internet Connection".localized)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return (self.imageArray.count) + 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if(indexPath.row < (self.imageArray.count))
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewImage", for: indexPath) as! CollectionViewImage
            let img = imageArray[indexPath.row]
            
            cell.img.image = img
            
            
            cell.removeImage.tag = indexPath.row
            cell.removeImage.addTarget(self, action: #selector(self.removeImage), for: .touchUpInside)
            
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewPlus", for: indexPath) as! CollectionViewPlus
            cell.btnPlus.addTarget(self, action: #selector(BtnHeart(_:)), for: .touchUpInside)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let size = collectionView.frame.width / 2 - 10
        return CGSize(width: size, height: 104)
    }
    
    @objc func BtnHeart(_ sender: UIButton)
    {
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title:"Images".localized, message: "Please select the image source".localized, preferredStyle: .actionSheet)
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel".localized, style: .cancel) { action -> Void in
            print("الغاء")
        }
        let saveActionButton: UIAlertAction = UIAlertAction(title: "Photo Library".localized, style: .default)
        { action -> Void in
            //Todo Upload image from Library
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        }
        let deleteActionButton: UIAlertAction = UIAlertAction(title: "Camera".localized, style: .default)
        { action -> Void in
            //ToDo Upload image From Camera
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
            
            print("الكاميرا")
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        actionSheetControllerIOS8.addAction(saveActionButton)
        actionSheetControllerIOS8.addAction(deleteActionButton)
        
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad )
        {
            if let currentPopoverpresentioncontroller = actionSheetControllerIOS8.popoverPresentationController {
                actionSheetControllerIOS8.popoverPresentationController?.sourceView = self.view
                actionSheetControllerIOS8.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                actionSheetControllerIOS8.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
                
                present(actionSheetControllerIOS8, animated: true, completion: nil)
            }
        }
        else
        {
            self.present(actionSheetControllerIOS8, animated: true, completion: nil)
        }
    }
    
    
    
    @objc func removeImage(_ sender:UIButton)
    {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let conent = self.TImages.object(at: sender.tag) as AnyObject
        let ImageId = conent.value(forKey: "id") as! Int
        
        //call delete image
        self.imageArray.remove(at: indexPath.row)
        self.DeleteImage(String(ImageId))
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let chosenImage = info[UIImagePickerControllerEditedImage]
        
        if(self.isVideo == false)
        {
            if(self.isProfileImage == true)
            {
                picker.dismiss(animated: true)
                {
                    let img = chosenImage as! UIImage?
                    self.img.image = img
                    self.isChangeImage = true
                }
            }
            else
            {
                picker.dismiss(animated: true)
                {
                    let img = chosenImage as! UIImage?
                    self.imageArray.append(img!)
                    self.newImageArray.append(img!)
                    self.col.reloadData()
                }
            }
            self.isProfileImage = false
        }
        else
        {
            let mediaType:AnyObject? = info[UIImagePickerControllerMediaType] as AnyObject?
            if let type:AnyObject = mediaType {
                if type is String {
                    let stringType = type as! String
                    if stringType == kUTTypeMovie as String
                    {
                        let urlOfVideo = info[UIImagePickerControllerMediaURL] as? NSURL
                        if let url = urlOfVideo
                        {
                            let asset = AVURLAsset(url:url as URL, options: nil)
                            let audioDuration = asset.duration
                            var audioDurationSeconds = CMTimeGetSeconds(audioDuration)
                            
                            print("time is \(audioDuration.seconds)")
                            do{
                                try self.videoData = NSData(contentsOf: url as URL)
                            }
                            catch
                            {
                                print("error")
                            }
                                let xx : String = (urlOfVideo?.relativePath)!
                                self.videoName = "Video uploaded successfully".localized
                        }
                    }
                }
            }
            picker.dismiss(animated: true, completion: {
                self.lblvideoName.text = "video1.mp4"
//                self.imgCamera.image = UIImage(named: "navHeader")
                self.isVideo = false
            })
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        self.isVideo = false
        self.isProfileImage = false
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnUploadVideo(_ sender: UIButton)
    {
        
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title:"Images".localized, message: "Please select the video source".localized, preferredStyle: .actionSheet)
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel".localized, style: .cancel) { action -> Void in
            print("الغاء")
        }
        let saveActionButton: UIAlertAction = UIAlertAction(title: "Photo Library".localized, style: .default)
        { action -> Void in
            //Todo Upload image from Library
            let picker = UIImagePickerController()
            picker.delegate = self
            self.isVideo = true
            picker.allowsEditing = true
            picker.sourceType = .photoLibrary
            picker.mediaTypes = [kUTTypeMovie as String]
            self.present(picker, animated: true, completion: nil)
        }
        let deleteActionButton: UIAlertAction = UIAlertAction(title: "Camera".localized, style: .default)
        { action -> Void in
            //ToDo Upload image From Camera
            let picker = UIImagePickerController()
            picker.delegate = self
            self.isVideo = true
            picker.allowsEditing = true
            picker.sourceType = .camera
            picker.mediaTypes = [kUTTypeMovie as String]
            picker.videoMaximumDuration = 180.0
            self.present(picker, animated: true, completion: nil)
            
            print("الكاميرا")
        }
        if(self.videoUrl != "")
        {
            let videoPlay: UIAlertAction = UIAlertAction(title: "Play Video", style: .default)
            { action -> Void in
                let VideoLink2 = NSURL(string:self.videoUrl)!
                self.playVideoWithout(url: VideoLink2)
            }
            actionSheetControllerIOS8.addAction(videoPlay)
        }
        
        actionSheetControllerIOS8.addAction(cancelActionButton)
        actionSheetControllerIOS8.addAction(saveActionButton)
        actionSheetControllerIOS8.addAction(deleteActionButton)
        
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad )
        {
            if let currentPopoverpresentioncontroller = actionSheetControllerIOS8.popoverPresentationController {
                actionSheetControllerIOS8.popoverPresentationController?.sourceView = self.view
                actionSheetControllerIOS8.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                actionSheetControllerIOS8.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
                
                present(actionSheetControllerIOS8, animated: true, completion: nil)
            }
        }
        else
        {
            self.present(actionSheetControllerIOS8, animated: true, completion: nil)
        }
    }
    
    func DeleteImage(_ ID:String)
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.DeleteImage(ID: ID)
                {(response, err) in
                    if((err) == nil)
                    {
                        if let JSON = response.result.value as? NSDictionary
                        {
                            let status = JSON["status"] as? Bool
                            if (status == true)
                            {
                                self.showOkAlertWithComp(title: "Success".localized, message: JSON["message"] as? String ?? "", completion: { (success) in
                                    if(success){
                                        self.col.reloadData()
                                    }
                                })
                            }
                            else
                            {
                                self.showOkAlert(title: "Error".localized, message: JSON["message"] as? String ?? "")
                            }
                        }
                        else
                        {
                            self.showOkAlert(title: "Error".localized, message: "An Error occurred".localized)
                        }
                        self.hideIndicator()
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
    
    
    func loadData()
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.GetUserProfile()
                {(response, err) in
                    if((err) == nil)
                    {
                        if let JSON = response.result.value as? NSDictionary
                        {
                            let status = JSON["status"] as? Bool
                            if (status == true)
                            {
                                let json = JSON["items"] as! NSDictionary
                                if(MyTools.tools.getUserType() == "handyman")
                                {
                                    self.txtNAme.text = json.value(forKeyPath: "name") as? String ?? ""
                                }
                                else
                                {
                                    self.txtNAme.text = json.value(forKeyPath: "company_name") as? String ?? ""
                                }
                                self.txtPhone.text = json.value(forKeyPath: "mobile") as? String
                                let img = json.value(forKeyPath: "profile_image") as? String ?? ""
                                self.txtEmail.text = json.value(forKeyPath: "email") as? String ?? ""
                                self.txtCivil.text = json.value(forKeyPath: "civil_id") as? String ?? ""
                                self.materialSwitch.isOn = json.value(forKeyPath: "is_24") as? Bool ?? false
                                self.img.sd_setImage(with: URL(string: img)!, placeholderImage: UIImage(named: "Avatar")!, options: SDWebImageOptions.refreshCached)
                                
                                if let video = json.value(forKeyPath: "video") as? String
                                {
                                    self.lblvideoName.text = "video1.mp4"
                                    self.playVideo.isHidden = true
                                    self.videobgImage.isHidden = false
                                    self.videoUrl = video
                                    
                                    do {
                                        let VideoLink2 = NSURL(string:video)!
                                        self.videoData = try Data(contentsOf: VideoLink2 as URL) as NSData
                                    } catch {
                                        print("Unable to load data: \(error)")
                                    }
//                                    self.videobgImage.image = UIImage(named: "navHeader")
                                }
                                else
                                {
                                    self.playVideo.isHidden = true
                                    self.videobgImage.isHidden = false
//                                    self.videobgImage.image = UIImage(named: "navHeader")
                                }
                                
                                self.TImages = json.value(forKey: "images") as? NSArray ?? []
                                let demoImage = UIImageView()
                                for index in 0..<self.TImages.count
                                {
                                    let content = self.TImages.object(at: index) as AnyObject
                                    let img = content.value(forKey: "image") as? String ?? ""
                                    demoImage.sd_setImage(with: URL(string: img), placeholderImage: UIImage(named: "10000-2"))
                                    self.imageArray.append(demoImage.image!)
                                    self.col.delegate = self
                                    self.col.dataSource = self
                                    self.col.reloadData()
                                }
                                
                                let types =  json.value(forKey: "categories") as? NSArray ?? []
                                self.lblType.text = ""
                                for index in 0..<types.count
                                {
                                    let content = types.object(at: index) as AnyObject
                                    let title = content.value(forKey: "title") as? String ?? ""
                                    let id = content.value(forKey: "id") as? Int ?? 0
                                    
                                    self.lblType.text = self.lblType.text!+title+", "
                                    
                                    self.selecetedarr.append(id)
                                }
                            }
                            else
                            {
                                self.showOkAlert(title: "Error".localized, message: JSON["message"] as? String ?? "")
                            }
                        }
                        else
                        {
                            self.showOkAlert(title: "Error".localized, message: "An Error occurred".localized)
                        }
                        self.hideIndicator()
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
    
    func playVideoWithout(url: NSURL)
    {
        let player = AVPlayer(url: url as URL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true)
        {() -> Void in
            playerViewController.player!.play()
        }
    }
    
    @IBAction func btnChange(_ sender: UIButton)
    {
        let vc:SAChangePassword = AppDelegate.storyboard.instanceVC()
        let popupViewController = BIZPopupViewController(contentViewController: vc, contentSize: CGSize(width: 250, height: 350))
        popupViewController?.showDismissButton = true
        popupViewController?.enableBackgroundFade = true
        self.present(popupViewController!, animated: true, completion: nil)
    }    
}

