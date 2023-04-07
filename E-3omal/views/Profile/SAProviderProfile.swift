//
//  SAProviderProfile.swift
//  E-3omal
//
//  Created by ibrahim M. samak on 7/10/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation
import AVKit
import GSImageViewerController

class SAProviderProfile: UIViewController , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout ,  UICollectionViewDataSource,UIScrollViewDelegate{
    
    @IBOutlet weak var col: UICollectionView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var llblEmail: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var FloatingView: FloatRatingView!
    
    var userId = 0
    var TImages = [String]()
    var chatFunctions = ChatFunctions()
    var ProviderImage = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setUpView()
        
        if(Language.currentLanguage().contains("ar"))
        {
            self.llblEmail.textAlignment = .right
            self.lblName.textAlignment = .right
            self.lblMobile.textAlignment = .right
        }
        else
        {
            self.llblEmail.textAlignment = .left
            self.lblName.textAlignment = .left
            self.lblMobile.textAlignment = .left
        }
        
        self.loadData()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func loadData()
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.GetProviderProfile(userId: String(self.userId))
            {(response, err) in
                if((err) == nil)
                {
                    if let JSON = response.result.value as? NSDictionary
                    {
                        let status = JSON["status"] as? Bool
                        if (status == true)
                        {
                            let json = JSON["items"] as! NSDictionary
                            let name = json.value(forKeyPath: "name") as? String
                            let video = json.value(forKeyPath: "video") as? String ?? ""
                            self.lblName.text = name
                            self.lblMobile.text = json.value(forKeyPath: "mobile") as? String
                            self.FloatingView.rating = Float(json.value(forKeyPath: "rate") as! Int)
                            self.ProviderImage = json.value(forKeyPath: "profile_image") as! String
                            self.llblEmail.text = json.value(forKeyPath: "email") as? String
                            self.img.sd_setImage(with: URL(string: self.ProviderImage)!, placeholderImage: UIImage(named: "Avatar")!, options: SDWebImageOptions.refreshCached)
                            let images =  json.value(forKeyPath: "images") as? NSArray ?? []
                            
                            if(video != "")
                            {
                                self.TImages.append(video)
                            }
                            
                            for index in 0..<images.count
                            {
                                let content = images.object(at: index) as AnyObject
                                let img = content.value(forKey: "image") as? String ?? ""
                                
                                self.TImages.append(img)
                            }
                            
                            
                            self.col.dataSource = self
                            self.col.delegate = self
                            self.col.reloadData()
                            
                            
                            self.navigationItem.title = name
                            self.infoView.isHidden = false
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
    
    func setUpView()
    {
        self.setupNavigationBarwithBack()
        let done = UIImageView(image:#imageLiteral(resourceName: "msgIcon"))
        done.frame = CGRect(x: CGFloat(5), y: CGFloat(10), width: CGFloat(22), height: CGFloat(15))
        let doneButton = UIButton(frame: CGRect(x: CGFloat(0), y: CGFloat(6), width: CGFloat(25), height: CGFloat(20)))
        doneButton.addSubview(done)
        doneButton.addTarget(self, action: #selector(self.msgButton(_:)), for: .touchUpInside)
        self.navigationItem.setRightBarButtonItems([UIBarButtonItem(customView: doneButton)], animated: true)
    }
    
    @objc func msgButton(_ sender: UIButton)
    {
        //navigation to chat button
        let otherUserId = String(self.userId)
        
        if(otherUserId != MyTools.tools.getMyId())
        {
            if(otherUserId != "")
            {
                let viewControllerB = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController

                chatFunctions.startChat(MyTools.tools.getMyId(), user2: otherUserId)
                
                viewControllerB?.senderId = MyTools.tools.getMyId()
                viewControllerB?.senderDisplayName = MyTools.tools.getMyKey("name")
                viewControllerB?.chatRoomId = chatFunctions.chatRoom_id
                viewControllerB?.reciverUid = otherUserId
                viewControllerB?.reciverName = self.lblName.text
                viewControllerB?.reciverImage = self.ProviderImage
                self.navigationController?.pushViewController(viewControllerB!, animated: true)
            }
            else
            {
                self.hideIndicator()
                self.showOkAlert(title: "Error".localized, message: "")
            }
        }
        else
        {
            self.hideIndicator()
            self.showOkAlert(title: "Error".localized, message: "Sorry Can't Open Chat This is Your Account".localized)
        }
    }
    
    
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.TImages.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCell
        let img = self.TImages[indexPath.row]
        if(img.contains(".mp4"))
        {
            cell.playImage.isHidden = false
        }
        else
        {
            cell.playImage.isHidden = true
        }
        
        cell.img.sd_setImage(with: URL(string: img)!, placeholderImage: UIImage(named: "10000-2")!, options: SDWebImageOptions.refreshCached)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let size = collectionView.frame.width / 3 - 10
        return CGSize(width: size, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let img = self.TImages[indexPath.row]
        if(img.contains(".mp4"))
        {
            // play video
            let VideoLink2 = NSURL(string:img)!
            self.playVideoWithout(url: VideoLink2)
            
        }
        else{
            // open image
            
            let url =  URL(string: img)!
            let key: String = SDWebImageManager.shared().cacheKey(for: url)!
            let cachedImage: UIImage? = SDImageCache.shared().imageFromDiskCache(forKey: key)
            
            if(cachedImage != nil)
            {
                let imageInfo   = GSImageInfo(image: cachedImage!, imageMode: .aspectFit)
                let transitionInfo = GSTransitionInfo(fromView: self.view)
                let imageViewer = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
                self.present(imageViewer, animated: true, completion: nil)
            }
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
    
}
