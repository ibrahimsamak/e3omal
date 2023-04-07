//
//  SASignUpContractor.swift
//  E-3omal
//
//  Created by ibrahim M. samak on 7/4/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//
import UIKit
import Firebase


class SASignUpContractor:  UIViewController , CategoryProtocol,
    UICollectionViewDelegate , UICollectionViewDelegateFlowLayout ,  UICollectionViewDataSource ,UIActionSheetDelegate ,UIImagePickerControllerDelegate , UINavigationControllerDelegate
{
    
    func sendCategory(CateogryNameArr: [String], CategoryArr: [Int])
    {
        if(CateogryNameArr.count > 0 ){
            self.txtType.text = ""
            self.selecetedarr = CategoryArr
            self.selecetedNamearr = CateogryNameArr
            print(self.selecetedarr)
            print(self.selecetedNamearr)
            
            for index in 0..<self.selecetedNamearr.count
            {
                self.txtType.text! += self.selecetedNamearr[index] as! String+", "
            }
            
            let index2 = self.txtType.text?.index((self.txtType.text?.startIndex)!, offsetBy: (self.txtType.text?.characters.count)!-2)
            self.txtType.text =  self.txtType.text?.substring(to: index2!)
        }
    }
    
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtCivilID: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtCompanyName: UITextField!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var col: UICollectionView!
    @IBOutlet weak var txtType: UILabel!
    @IBOutlet weak var arrow: UIImageView!
    @IBOutlet weak var arrow2: UIImageView!
    
    var selecetedarr = [Int]()
    var selecetedNamearr = [String]()
    var imageArray : [UIImage] = []
    var is24 = 1
    var isChangeImage = false
    var entries : NSDictionary!
    var isProfileImage = false
    private var isConfirm = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(Language.currentLanguage().contains("ar"))
        {
            self.txtCivilID.textAlignment = .right
            self.txtPassword.textAlignment = .right
            self.txtEmail.textAlignment = .right
            self.txtPhone.textAlignment = .right
            self.txtType.textAlignment = .right
            self.txtName.textAlignment = .right
            self.txtCompanyName.textAlignment = .right
            self.arrow.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.arrow2.transform = CGAffineTransform(scaleX: -1, y: 1)

        }
        else
        {
            self.txtCivilID.textAlignment = .left
            self.txtPassword.textAlignment = .left
            self.txtEmail.textAlignment = .left
            self.txtPhone.textAlignment = .left
            self.txtType.textAlignment = .left
            self.txtName.textAlignment = .left
            self.txtCompanyName.textAlignment = .left
        }
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
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
        
        self.imageArray.remove(at: indexPath.row)
        self.col.reloadData()
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let chosenImage = info[UIImagePickerControllerEditedImage]
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
                self.col.reloadData()
            }
        }
        self.isProfileImage = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        self.isProfileImage = false
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func btnUpload(_ sender: Any)
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
    
    @IBAction func btnBack(_ sender: UIButton)
    {
        self.navigationController?.pop(animated: true)
    }
    
    @IBAction func btnChooseType(_ sender: UIButton)
    {
        let vc:SACategories = AppDelegate.storyboard.instanceVC()
        vc.isContractor = true
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnSignUp(_ sender: UIButton)
    {
        if MyTools.tools.connectedToNetwork()
        {
            if(txtCompanyName.text?.count == 0 || txtName.text?.count == 0 || txtPhone.text?.count == 0 || txtEmail.text?.count == 0 || txtPassword.text?.count == 0 )
            {
                self.showOkAlert(title: "Error".localized, message: "All fields are required".localized)
            }
            else if txtName.text?.count == 0
            {
                self.showOkAlert(title: "Error".localized, message: "Please enter your name".localized)
            }
            else if txtCompanyName.text?.count == 0
            {
                self.showOkAlert(title: "Error".localized, message: "Please enter company name".localized)
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
            else if txtPassword.text?.count == 0{
                self.showOkAlert(title: "Error".localized, message: "Please enter your password".localized)
            }
            else if self.isChangeImage == false{
                self.showOkAlert(title: "Error".localized, message: "Please enter image profile".localized)
            }
            else if  self.selecetedarr.count == 0{
                self.showOkAlert(title: "Error".localized, message: "Please select one type at least (you can choose more than one)".localized)
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
                let type = MyApi.userType.contractor.rawValue
                self.showIndicator()
                MyApi.api.PostSignUpNewUser(name: txtName.text!, email: txtEmail.text!, mobile:txtPhone.text! , password: txtPassword.text!, type: type, is_24: "0", company_name: txtCompanyName.text!, category_id: self.selecetedarr, profile_image: image!, civil_id: self.txtCivilID.text!, images:  self.imageArray, token: deviceToken!) { (response, error) in
                    if(response.result.value != nil)
                    {
                        if let JSON = response.result.value as? NSDictionary
                        {
                            let status = JSON["status"] as? Int
                            if(status == 1)
                            {
                                self.hideIndicator()
                                self.showOkAlertWithComp(title: "Success".localized, message:  JSON["message"] as? String ?? "", completion: { (Success) in
                                    if(Success)
                                    {
                                        self.reinitialize()
                                        let vc : SAVerifySms = AppDelegate.storyboard.instanceVC()
                                        vc.mobileNo = self.txtPhone.text!
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
    
    func reinitialize(){
        self.txtCompanyName.text = ""
        self.txtEmail.text = ""
        self.txtPhone.text = ""
        self.txtPassword.text = ""
        self.txtPassword.text = ""
        self.txtCivilID.text = ""
        self.selecetedarr = []
        self.imageArray = []
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
