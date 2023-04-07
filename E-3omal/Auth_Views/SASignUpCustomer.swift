//
//  SASignUpCustomer.swift
//  E-3omal
//
//  Created by ibrahim M. samak on 7/4/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase

class SASignUpCustomer: UIViewController , UIActionSheetDelegate ,UIImagePickerControllerDelegate , UINavigationControllerDelegate{

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtphone: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var txtpassword: UITextField!
    @IBOutlet weak var arrow: UIImageView!
    
    var isChangeImage = false
    var entries : NSDictionary!
    private var isConfirm = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(Language.currentLanguage().contains("ar"))
        {
            self.txtphone.textAlignment = .right
            self.txtEmail.textAlignment = .right
            self.txtName.textAlignment = .right
            self.txtpassword.textAlignment = .right
            self.arrow.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        else
        {
            self.txtphone.textAlignment = .left
            self.txtEmail.textAlignment = .left
            self.txtName.textAlignment = .left
            self.txtpassword.textAlignment = .left
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    @IBAction func btnBack(_ sender: UIButton)
    {
        self.navigationController?.pop(animated: true)
    }
    
    @IBAction func btnUploadImage(_ sender: UIButton)
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
    

    @IBAction func btnSignUp(_ sender: UIButton)
    {
        if MyTools.tools.connectedToNetwork()
        {
            if(txtName.text?.count == 0 || txtphone.text?.count == 0 || txtEmail.text?.count == 0 || txtpassword.text?.count == 0 )
            {
                self.showOkAlert(title: "Error".localized, message: "All fields are required".localized)
            }
            else if txtName.text?.count == 0
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
            else if txtpassword.text?.count == 0{
                self.showOkAlert(title: "Error".localized, message: "Please enter your password".localized)
            }
            else if self.isChangeImage == false{
                self.showOkAlert(title: "Error".localized, message: "Please enter image profile".localized)
            }
            else if  self.isConfirm == false{
                self.showOkAlert(title: "Error".localized, message: "Please agree terms & condetions".localized)
            }
            else{
                var deviceToken = MyTools.tools.getDeviceToken()
                if deviceToken == nil
                {
                    deviceToken = InstanceID.instanceID().token()!
                }
                let image = UIImageJPEGRepresentation(self.img.image!, 0.8) as? Data
                let type = MyApi.userType.customer.rawValue
                self.showIndicator()
                MyApi.api.PostSignUpNewUser(name: txtName.text!, email: txtEmail.text!, mobile:txtphone.text! , password: txtpassword.text!, type: type, is_24: "0", company_name: "", category_id: [1], profile_image: image!, civil_id: "", images: [], token: deviceToken!) { (response, error) in
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
                                        let vc : SAVerifySms = AppDelegate.storyboard.instanceVC()
                                        vc.mobileNo = self.txtphone.text!
                                        self.navigationController?.pushViewController(vc, animated: true)
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
    
    
    @IBAction func btnStatic(_ sender: UIButton)
    {
        if(sender.tag == 1 )
        {
         //terms
            let vc:SAStaticPage = AppDelegate.storyboard.instanceVC()
            vc.PageType = "terms"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
          // privacy
            let vc:SAStaticPage = AppDelegate.storyboard.instanceVC()
            vc.PageType = "privacy"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func isConfirmClick(_ sender: UIButton)
    {
        isConfirm = !isConfirm
        let img = isConfirm ? #imageLiteral(resourceName: "checkedIcon10") : #imageLiteral(resourceName: "unchecked")
        sender.setImage(img, for: .normal)
    }
}
