//
//  SANewJob.swift
//  E-3omal
//
//  Created by ibrahim M. samak on 7/9/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import GooglePlaces
import GooglePlacePicker
import UITextView_Placeholder


class SANewJob: UIViewController, CategoryProtocol , UIActionSheetDelegate ,UIImagePickerControllerDelegate , UINavigationControllerDelegate,GMSPlacePickerViewControllerDelegate
{
    
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace)
    {
        viewController.dismiss(animated: true, completion: nil)
        self.latitude = Double(place.coordinate.latitude)
        self.longitude = Double(place.coordinate.longitude)
        
        if  place.formattedAddress != nil
        {
            let address = (place.formattedAddress?.components(separatedBy: ", ")
                .joined(separator: "\n"))!
            self.txtLocation.text = address
        }
        else
        {
            self.getAddress()
        }
    }
    
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController)
    {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtbudget: UITextField!
    @IBOutlet weak var txtType: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtNameEn: UITextField!
    @IBOutlet weak var txtDetailsAr: UITextView!
    @IBOutlet weak var txtEnDetails: UITextView!
    @IBOutlet weak var txtEnAddress: UITextField!
  
    @IBOutlet weak var arrow: UIImageView!
    var selecetedarr = [Int]()
    var selecetedNamearr = [String]()
    var imageArray : [UIImage] = []
    var isMaterial = 1
    var isChangeImage = false
    var entries : NSDictionary!
    var Tcategory : NSArray = []
    
    var latitude = 0.0
    var longitude = 0.0

    func sendCategory(CateogryNameArr: [String], CategoryArr: [Int])
    {
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBarwithBack()
        self.navigationItem.title =  "Post a job"
        
        if(Language.currentLanguage().contains("ar"))
        {
            self.txtType.textAlignment = .right
            self.txtTitle.textAlignment = .right
            self.txtbudget.textAlignment = .right
            self.txtNameEn.textAlignment = .right
            self.txtAddress.textAlignment = .right
            self.txtLocation.textAlignment = .right
            self.txtEnAddress.textAlignment = .right
            self.txtDetailsAr.textAlignment = .right
            self.txtEnDetails.textAlignment = .right
           
            self.txtDetailsAr.placeholder = "الوصف باللغة العربية"
            self.txtDetailsAr.placeholderColor = "BAB9C9".color
            self.txtEnDetails.placeholder = "الوصف باللغة الانجليزية"
            self.txtEnDetails.placeholderColor = "BAB9C9".color
            self.arrow.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        else
        {
            self.txtType.textAlignment = .left
            self.txtTitle.textAlignment = .left
            self.txtbudget.textAlignment = .left
            self.txtNameEn.textAlignment = .left
            self.txtAddress.textAlignment = .left
            self.txtLocation.textAlignment = .left
            self.txtEnAddress.textAlignment = .left
            self.txtDetailsAr.textAlignment = .left
            self.txtEnDetails.textAlignment = .left
            
            self.txtDetailsAr.placeholder = "Job Details Ar"
            self.txtDetailsAr.placeholderColor = "BAB9C9".color
            self.txtEnDetails.placeholder = "Job Details En"
            self.txtEnDetails.placeholderColor = "BAB9C9".color
        }
        
    }
    
    @IBAction func btnPost(_ sender: UIButton)
    {
        if MyTools.tools.connectedToNetwork()
        {
            if txtTitle.text?.count == 0
            {
                self.showOkAlert(title: "Error".localized, message: "Please enter job arabic title".localized)
            }
            if txtNameEn.text?.count == 0
            {
                self.showOkAlert(title: "Error".localized, message: "Please enter job engilsh title".localized)
            }
            else if txtDetailsAr.text?.count == 0 {
                self.showOkAlert(title: "Error".localized, message: "Please enter job arabic description".localized)
            }
            else if txtEnDetails.text?.count == 0 {
                self.showOkAlert(title: "Error".localized, message: "Please enter job engilsh description".localized)
            }
            else if txtAddress.text?.count == 0{
                self.showOkAlert(title: "Error".localized, message: "Please enter job arabic address".localized)
            }
            else if txtEnAddress.text?.count == 0{
                self.showOkAlert(title: "Error".localized, message: "Please enter job english address".localized)
            }
            else if txtbudget.text?.count == 0{
                self.showOkAlert(title: "Error".localized, message: "Please enter job budget".localized)
            }
            else if self.selecetedarr.count == 0{
                self.showOkAlert(title: "Error".localized, message: "Please enter select type of the job".localized)
            }
            else if  txtLocation.text?.count == 0{
                self.showOkAlert(title: "Error".localized, message: "Please enter select Location of the job".localized)
            }
            else if  self.isChangeImage == false{
                self.showOkAlert(title: "Error".localized, message: "Please enter image of the job".localized)
            }
            else
            {
                self.showIndicator()
                let category_id = self.selecetedarr[0]
                let image = UIImageJPEGRepresentation(self.img.image!, 0.8) as? Data
                MyApi.api.PostNewJob(title_en: txtNameEn.text!, details_en: txtEnDetails.text!, address_en: txtEnAddress.text!, title_ar: txtTitle.text!, details_ar: txtDetailsAr.text!, address_ar: txtAddress.text!,lat: self.latitude, lan: self.longitude, budget: Int(txtbudget.text!)!, building_material: self.isMaterial, category_id: category_id, image: image!)
                    {(response, error) in
                    if(response.result.value != nil)
                    {
                        if let JSON = response.result.value as? NSDictionary
                        {
                            let status = JSON["status"] as? Int
                            if(status == 1)
                            {
                                self.hideIndicator()
                                self.showOkAlertWithComp(title: "Success".localized, message:  JSON["message"] as? String ?? "", completion:
                                    { (Success) in
                                    if(Success)
                                    {
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
                        self.showOkAlert(title: "Error".localized, message: "An Error occurred please try again later")
                    }
                }
            }
        }
        else
        {
            self.showOkAlert(title: "Error".localized, message: "No Internet Connection".localized)
        }
    }
    
    @IBAction func btnUpload(_ sender: UIButton) {
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
            let img = chosenImage as! UIImage?
            self.img.image = img
            self.isChangeImage = true
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func btnType(_ sender: UIButton)
    {
        let vc:SACategories = AppDelegate.storyboard.instanceVC()
        vc.isContractor = false
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func switchChange(_ sender: UISwitch)
    {
        if sender.isOn{
            self.isMaterial = 1
        }
        else{
            self.isMaterial = 0
        }
    }
    
    @IBAction func btnLocation(_ sender: UIButton)
    {
        let config = GMSPlacePickerConfig(viewport: nil)
        let placePicker = GMSPlacePickerViewController(config: config)
        placePicker.delegate = self
        self.present(placePicker, animated: true, completion: nil)
    }
    
    
    func getAddress()
    {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: self.latitude, longitude: self.longitude)
        geoCoder.cancelGeocode()
        geoCoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            
            var addressString: String! = ""
            
            let placemark = placemarks?.last!
            if placemark?.subThoroughfare != nil
            {
                addressString = (placemark?.subThoroughfare!)! + " "
            }
            if placemark?.thoroughfare != nil
            {
                addressString = addressString + (placemark?.thoroughfare!)! + ", "
            }
            if placemark?.postalCode != nil
            {
                addressString = addressString + (placemark?.postalCode!)! + " "
            }
            if placemark?.locality != nil
            {
                addressString = addressString + (placemark?.locality!)! + ", "
            }
            if placemark?.administrativeArea != nil
            {
                addressString = addressString + (placemark?.administrativeArea!)! + " "
            }
            if placemark?.country != nil
            {
                addressString = addressString + (placemark?.country!)!
            }
            
            self.txtLocation.text = addressString
        })
    }
    
}
