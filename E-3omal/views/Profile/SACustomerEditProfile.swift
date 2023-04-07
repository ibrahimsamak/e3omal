//
//  SACustomerEditProfile.swift
//  E-3omal
//
//  Created by ibrahim M. samak on 7/12/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
import BIZPopupView

class SACustomerEditProfile: UIViewController , UIActionSheetDelegate ,UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtphone: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var img: UIImageView!
    
    var isChangeImage = false
    var entries : NSDictionary!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setupNavigationBarwithBack()
        self.navigationItem.title = "Edit Profile".localized
        
        if(Language.currentLanguage().contains("ar"))
        {
            self.txtName.textAlignment = .right
            self.txtphone.textAlignment = .right
            self.txtEmail.textAlignment = .right
        }
        else
        {
            self.txtName.textAlignment = .left
            self.txtphone.textAlignment = .left
            self.txtEmail.textAlignment = .left
        }
        
        
        self.loadData()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnUpload(_ sender: UIButton)
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
            
            print("مكتبة الصورة")
        }
        let deleteActionButton: UIAlertAction = UIAlertAction(title: "Camera".localized, style: .default)
        { action -> Void in
            //ToDo Upload image From Camera
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = .camera
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
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let chosenImage = info[UIImagePickerControllerEditedImage]
        picker.dismiss(animated: true)
        {
            self.img!.image = chosenImage as! UIImage?
            self.img.contentMode = .scaleAspectFit
            self.isChangeImage = true
        }
        self.img!.image = chosenImage as! UIImage?
        self.img.contentMode = .scaleAspectFit
        self.isChangeImage = true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnSave(_ sender: UIButton)
    {
        if MyTools.tools.connectedToNetwork()
        {
            if txtName.text?.count == 0
            {
                self.showOkAlert(title: "Error".localized, message: "Please enter your name".localized)
            }
            else if txtphone.text?.count == 0{
                self.showOkAlert(title: "Error".localized, message: "Please enter your phone number".localized)
            }
                
            else if txtEmail.text?.count == 0{
                self.showOkAlert(title: "Error".localized, message: "Please enter your email address".localized)
            }
            else if !MyTools.tools.validateEmail(candidate: txtEmail.text!){
                self.showOkAlert(title: "Error".localized, message: "Please enter valid email address".localized)
            }
            else{
                let image = UIImageJPEGRepresentation(self.img.image!, 0.8) as? Data
                let type = MyApi.userType.customer.rawValue
                self.showIndicator()
                MyApi.api.PostEditUser(name: txtName.text!, email: txtEmail.text!, mobile: txtphone.text!,image: image!, civil_id: "", images: [UIImage](), is_24: "", video: Data(), company_name: "", category_id: [Int]())
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
                                                "email":UserArray?.value(forKey: "email") as! String , "id":UserArray?.value(forKey: "id") as! Int, "name":UserArray?.value(forKey: "name") as! String ,
                                                "profile_image": UserArray?.value(forKey: "profile_image") as? String ?? ""  ,
                                                "mobile":UserArray?.value(forKey: "mobile") as! String ,
                                                "access_token":UserArray?.value(forKey: "token") as! String,
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
                                self.txtName.text = json.value(forKeyPath: "name") as? String
                                self.txtphone.text = json.value(forKeyPath: "mobile") as? String
                                let img = json.value(forKeyPath: "profile_image") as? String
                                self.txtEmail.text = json.value(forKeyPath: "email") as? String
                                self.img.sd_setImage(with: URL(string: img!)!, placeholderImage: UIImage(named: "Avatar")!, options: SDWebImageOptions.refreshCached)
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
    
    @IBAction func btnChange(_ sender: UIButton)
    {
        let vc:SAChangePassword = AppDelegate.storyboard.instanceVC()
        let popupViewController = BIZPopupViewController(contentViewController: vc, contentSize: CGSize(width: 250, height: 350))
        popupViewController?.showDismissButton = true
        popupViewController?.enableBackgroundFade = true
        self.present(popupViewController!, animated: true, completion: nil)
    }
    
}
