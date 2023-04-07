
//
//  SAContactUs.swift
//  E-3omal
//
//  Created by ibrahim M. samak on 7/11/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit
import SafariServices
import UITextView_Placeholder

class SAContactUs: UIViewController, GMSMapViewDelegate , CLLocationManagerDelegate
{

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("error description:\(error.localizedDescription)")
    }
    
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtMsg: UITextView!
    @IBOutlet weak var GPS: GMSMapView!
    
    let locationManag = CLLocationManager()
    var Latitude : Double = 0
    var Longitude : Double = 0
    let marker = GMSMarker()
    var target: CLLocationCoordinate2D?
    var total = ""
    var long = 0.0
    var lat = 0.0
    var result: Int!
    var entries : NSDictionary!
    var arr:[Any] = []
    
    func func_initLocation()
    {
        if (CLLocationManager.locationServicesEnabled())
        {
            switch(CLLocationManager.authorizationStatus())
            {
            case .notDetermined, .restricted, .denied:
                AppDelegate.locationManager.requestWhenInUseAuthorization()
                AppDelegate.locationManager.requestAlwaysAuthorization()
                
            case .authorizedAlways, .authorizedWhenInUse:
                AppDelegate.locationManager.delegate = self
                AppDelegate.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
                AppDelegate.locationManager.startUpdatingLocation()
                
                self.Latitude = (AppDelegate.locationManager.location?.coordinate.latitude)!
                self.Longitude = (AppDelegate.locationManager.location?.coordinate.longitude)!
            }
        }
        else
        {
            AppDelegate.locationManager.requestWhenInUseAuthorization()
            AppDelegate.locationManager.requestAlwaysAuthorization()
        }
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.title = "Contact Us".localized
        self.setupNavigationBarwithBack()
        
        GPS.isMyLocationEnabled = true
        GPS.settings.myLocationButton = false
        GPS.settings.zoomGestures = true
        GPS.settings.scrollGestures = true
        GPS.mapType = .normal
        GPS.delegate = self
        
        
        self.Latitude = Double(MyTools.tools.getConfigString("latitude"))!
        self.Longitude = Double(MyTools.tools.getConfigString("longitude"))!
        lblEmail.text = MyTools.tools.getConfigString("info_email")
        lblPhone.text = MyTools.tools.getConfigString("mobile")
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(self.Latitude,self.Longitude)
        let x: Float = Float(CGFloat (GPS.frame.size.width /  2))
        let y: Float = Float(CGFloat(GPS.frame.size.height / 2))
        let markerImg = UIImageView(frame: CGRect(x: CGFloat(x - 20), y: CGFloat(y - 32), width: CGFloat(30), height: CGFloat(30)))
        markerImg.image = UIImage(named: "marker")
        GPS.addSubview(markerImg)
        
        
        delay(seconds:0.5) { () -> () in
            self.delay(seconds: 0.5, closure: { () -> () in
                let vancouver = CLLocationCoordinate2DMake(self.Latitude,self.Longitude)
                var vancouverCam = GMSCameraUpdate.setTarget(vancouver)
                self.GPS.animate(toLocation: vancouver)
                
                self.delay(seconds: 0.5, closure: { () -> () in
                    let zoomIn = GMSCameraUpdate.zoom(to: 15)
                    self.GPS.animate(with: zoomIn)
                    
                })
            })
        }
        
        if(Language.currentLanguage().contains("ar"))
        {
            self.lblEmail.textAlignment = .right
            self.lblPhone.textAlignment = .right
            self.txtMsg.textAlignment = .right
            self.txtName.textAlignment = .right
            self.txtEmail.textAlignment = .right
            self.txtMobile.textAlignment = .right
            
            self.txtMsg.placeholder = "الرسالة"
            self.txtMsg.placeholderColor = "BAB9C9".color
        }
        else
        {
            self.lblEmail.textAlignment = .left
            self.lblPhone.textAlignment = .left
            self.txtMsg.textAlignment = .left
            self.txtName.textAlignment = .left
            self.txtEmail.textAlignment = .left
            self.txtMobile.textAlignment = .left
            
            self.txtMsg.placeholder = "Message"
            self.txtMsg.placeholderColor = "BAB9C9".color
        }
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition)
    {
        let coordinate = position.target
        let lat = coordinate.latitude
        let lon = coordinate.longitude
        self.lat = coordinate.latitude
        self.long = coordinate.longitude
        print(lat,lon)
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func btnAdd(_ sender: UIButton)
    {
        if MyTools.tools.connectedToNetwork()
        {
            if txtName.text?.count == 0
            {
                self.showOkAlert(title: "Error".localized, message: "Please enter your name".localized)
            }
            else if txtMobile.text?.count == 0{
                self.showOkAlert(title: "Error".localized, message: "Please enter your phone number".localized)
            }
            else if txtEmail.text?.count == 0{
                self.showOkAlert(title: "Error".localized, message: "Please enter your email address".localized)
            }
            else if !MyTools.tools.validateEmail(candidate: txtEmail.text!){
                self.showOkAlert(title: "Error".localized, message: "Please enter valid email address".localized)
            }
            else if txtMsg.text?.count == 0{
                self.showOkAlert(title: "Error".localized, message: "Please enter your message".localized)
            }
            else{
                self.showIndicator()
                MyApi.api.PostContact(name: txtName.text!, email: txtEmail.text!, message: txtMsg.text!, mobile: txtMobile.text!) { (response, error) in
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
                        self.showOkAlert(title: "Error".localized.localized, message: "An Error occurred".localized)
                    }
                }
            }
        }
        else{
            self.showOkAlert(title: "Error".localized, message: "No Internet Connection".localized)
        }
    }
    
    
    func delay(seconds: Double, closure: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            closure()
        }
    }
    
    
    @IBAction func btnSocial(_ sender: UIButton)
    {
        if(sender.tag == 1)
        {
            //twitter
            let urlString = MyTools.tools.getConfigString("twitter")
            let url = URL(string: urlString)
            let vc = SFSafariViewController(url: url!)
            present(vc, animated: true, completion: nil)
        }
        else
        {
            //facebook
            let urlString = MyTools.tools.getConfigString("facebook")
            let url = URL(string: urlString)
            let vc = SFSafariViewController(url: url!)
            present(vc, animated: true, completion: nil)
        }
    }
    
}
