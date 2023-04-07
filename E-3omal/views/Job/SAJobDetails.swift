//
//  SAJobDetails.swift
//  E-3omal
//
//  Created by ibrahim M. samak on 7/9/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import SDWebImage
import GSImageViewerController
import BIZPopupView
import MapKit

class SAJobDetails: UIViewController
{
    @IBOutlet weak var lblInclude: UILabel!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblBudget: UILabel!
    
    var content : AnyObject!
    var job_id = 0
    var lang = 0.0
    var long = 0.0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setupNavigationBarwithBack()
        self.navigationItem.title =  "Job Details".localized
        //        guard let labelText = label1.text else { return }
        //        let height = estimatedHeightOfLabel(text: labelText)
        //        print(height)
        
        if(MyTools.tools.getUserType() == "customer")
        {
            self.btn.isHidden = true
        }
        
        
        if(Language.currentLanguage().contains("ar"))
        {
            self.label1.textAlignment = .right
            self.lblTitle.textAlignment = .right
            self.lblCategory.textAlignment = .right
            self.lblCategory.textAlignment = .right
            self.lblDate.textAlignment = .right
            self.lblLocation.textAlignment = .right
            self.lblBudget.textAlignment = .right
        }
        else
        {
            self.label1.textAlignment = .left
            self.lblTitle.textAlignment = .left
            self.lblCategory.textAlignment = .left
            self.lblCategory.textAlignment = .left
            self.lblDate.textAlignment = .left
            self.lblLocation.textAlignment = .left
            self.lblBudget.textAlignment = .left
        }
        
        
        self.setupValues()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    func estimatedHeightOfLabel(text: String) -> CGFloat {
        let size = CGSize(width: view.frame.width - 16, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [kCTFontAttributeName: UIFont.systemFont(ofSize: 15)]
        let rectangleHeight = String(text).boundingRect(with: size, options: options, attributes: attributes as [NSAttributedStringKey : Any], context: nil).height
        return rectangleHeight
    }
    
    
    @IBAction func btnOpenImage(_ sender: UIButton)
    {
        if (self.img.image != UIImage(named: "10000-2"))
        {
            let imageInfo   = GSImageInfo(image: self.img.image!, imageMode: .aspectFit)
            let transitionInfo = GSTransitionInfo(fromView: self.view)
            let imageViewer = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
            self.present(imageViewer, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func btnMakeOffer(_ sender: UIButton)
    {
        // make offer button
        self.openPopUpView(1,job_id)
    }
    
    
    func setupValues()
    {
        let budget = content.value(forKey: "budget") as? Double ?? 0.0
        let title = content.value(forKey: "title") as! String
        let details = content.value(forKey: "details") as! String
        let address = content.value(forKey: "address") as! String
//        let categoryArr = content.value(forKey: "category") as? NSDictionary ?? [:]
//        let categoryName = categoryArr.value(forKey: "title") as? String ?? ""
        let image = content.value(forKey: "image") as! String
        let created_at = content.value(forKey: "created_at") as! String
        let categoryName = content.value(forKey: "category_title") as? String ?? ""
        let building_material = content.value(forKey: "building_material") as! Int

        
        self.job_id = content.value(forKey: "id") as! Int
        self.lang = content.value(forKey: "lat") as! Double
        self.long = content.value(forKey: "lan") as! Double
        
        lblTitle.text = title
        label1.text = details
        lblCategory.text = categoryName
        lblLocation.text = address
        lblBudget.text = String(budget)+" K.D".localized
        lblDate.text = MyTools.tools.convertDateFormater(date: created_at)
        img.sd_setImage(with: URL(string: image)!, placeholderImage: UIImage(named: "10000-2")!, options: SDWebImageOptions.refreshCached)
       
        if building_material == 1 {
            lblInclude.text = "Yes".localized
        }else{
            lblInclude.text = "No".localized
        }
    }
    
    
    func openPopUpView(_ type:Int ,_ job_id:Int)
    {
        let vc:SAPopUp = AppDelegate.storyboard.instanceVC()
        vc.type = type
        vc.job_id = job_id
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let popupViewController = BIZPopupViewController(contentViewController: vc, contentSize: CGSize(width: screenWidth, height: screenHeight))
        popupViewController?.showDismissButton = true
        popupViewController?.enableBackgroundFade = true
        self.present(popupViewController!, animated: true, completion: nil)
    }
    
    
    @IBAction func btnOpenMap(_ sender: UIButton)
    {
        let lat1 : Double = (self.lang)
        let lng1 : Double = (self.long)
        
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: lat1, longitude: lng1)))
        destination.name = self.lblTitle.text
        MKMapItem.openMaps(with: [destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
}
