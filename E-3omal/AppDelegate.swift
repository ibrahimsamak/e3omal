//
//  AppDelegate.swift
//  E-3omal
//
//  Created by ibrahim M. samak on 7/4/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import Firebase
import UserNotifications
import BRYXBanner


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , CLLocationManagerDelegate{
    let gcmMessageIDKey = "gcm.message_id"

    static var locationManager = CLLocationManager()
    public var mainRootNav: UINavigationController?
    static let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
    var window: UIWindow?
    var entries : NSDictionary!
    
    override init()
    {
        super.init()
        UIApplication.shared.registerForRemoteNotifications()
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = false
    }
    
    
    public func application(received remoteMessage: MessagingRemoteMessage)
    {
        print(remoteMessage.appData);
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
    {
        
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UIApplication.shared.statusBarStyle = .lightContent
        Localizer.DoTheExchange()

        
        IQKeyboardManager.shared.enable = true
        GMSServices.openSourceLicenseInfo()
        GMSServices.provideAPIKey("AIzaSyBbU-Dgqcyspe2S3-MfwGkZlBwtAPnfZM0")
        GMSPlacesClient.provideAPIKey("AIzaSyBbU-Dgqcyspe2S3-MfwGkZlBwtAPnfZM0")
        
        
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        UINavigationBar.appearance().tintColor = UIColor.white
        
        
        
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
        UITabBar.appearance().barTintColor = UIColor.white
        UITabBar.appearance().tintColor =  MyTools.tools.colorWithHexString("464373")
        
        
        self.startUpdateLocation()
        if CLLocationManager.locationServicesEnabled()
        {
            switch(CLLocationManager.authorizationStatus())
            {
            case .notDetermined, .restricted, .denied:
                print("No access")
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            }
        }
        else
        {
            print("Location services are not enabled")
        }
        
        Messaging.messaging().delegate = self
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        self.SetupConfig()
       // self.setupView()
        return true
    }
    

    func applicationWillResignActive(_ application: UIApplication)
    {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication)
    {
        application.applicationIconBadgeNumber = 0
        
//        if self.window!.rootViewController is SAMainTabbar
//        {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let rootController = storyboard.instantiateViewController(withIdentifier: "SAAdvNavigation") as? SAAdvNavigation
//            if let window = self.window {
//                window.rootViewController = rootController
//                self.window?.makeKeyAndVisible()
//            }
//        }
//        else{
//
//        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication)
    {
       
    }
    
    func applicationDidBecomeActive(_ application: UIApplication)
    {
//        if self.window!.rootViewController is SAMainTabbar
//        {
//            
//        }
//        else{
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let rootController = storyboard.instantiateViewController(withIdentifier: "SAAdvNavigation") as? SAAdvNavigation
//            if let window = self.window {
//                window.rootViewController = rootController
//                self.window?.makeKeyAndVisible()
//            }
//        }
    }
    
    func applicationWillTerminate(_ application: UIApplication)
    {
        
    }
    

    
    func setupView(){
        if ((UserDefaults.standard.object(forKey: "CurrentUser")) != nil)
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabBarController = storyboard.instantiateViewController(withIdentifier: "SAMainTabbar") as? SAMainTabbar
            if let window = self.window
            {
                window.rootViewController = tabBarController
                self.window?.makeKeyAndVisible()
            }
        }
        else
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let rootController = storyboard.instantiateViewController(withIdentifier: "SAAdvNavigation") as? SAAdvNavigation
            if let window = self.window {
                window.rootViewController = rootController
                //self.window?.makeKeyAndVisible()
            }
        }
    }
    
    func SetupConfig()
    {
        if MyTools.tools.connectedToNetwork()
        {
            MyApi.api.GetConfig(){(response, err) in
                if((err) == nil)
                {
                    if let JSON = response.result.value as? NSDictionary
                    {
                        let status = JSON["status"] as? Bool
                        if (status == true)
                        {
                            let items = JSON["items"] as! NSDictionary       
                            for (key,value) in items {
                                print("\(key) = \(value)")
                                let val = value as? String ?? ""
                                let ns = UserDefaults.standard
                                ns.setValue(val, forKey: key as! String)
                                ns.synchronize()
                            }
                        }
                        else
                        {
                            
                        }
                    }
                    else
                    {
                        
                    }
                    
                }
                else
                {
                    
                }
            }
        }
        else
        {
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let userLocation = locations[0] as CLLocation
    }
    
    func startUpdateLocation()
    {
        // Ask for user authorization when getting location
        AppDelegate.locationManager.requestAlwaysAuthorization()
        AppDelegate.locationManager.requestWhenInUseAuthorization()
    }
    
}
// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        //clicked
        let state = UIApplication.shared.applicationState
        print(state)

        if let aps = userInfo["aps"] as? [String:Any] {
            if let alert = aps["alert"] as? [String:Any] {
                let body = alert["body"] as? String ?? ""
                let title = alert["title"] as? String ?? ""
                
                let banner = Banner(title: title, subtitle: body, image: nil, backgroundColor: "0086B4".color)
                NotificationCenter.default.post(name: NSNotification.Name("UpdateChat"), object: nil)
                banner.dismissesOnSwipe = true
                banner.show(duration: 3.0)
                banner.didTapBlock = {
                    if(userInfo["gcm.notification.type"] as! String == "3")
                    {                        
                        let vcChat : ChatsTableVC = AppDelegate.storyboard.instanceVC()
                        let vc : SAMainTabbar = AppDelegate.storyboard.instanceVC()
                        vc.selectedIndex = 4
                        
                        self.window?.rootViewController = vc
                        self.window?.makeKeyAndVisible()
                        self.mainRootNav?.pushViewController(vcChat, animated: true)
                    }
                    else
                    {
                        let vc : SAMainTabbar = AppDelegate.storyboard.instanceVC()
                        vc.selectedIndex = 2
                        
                        let appDelegate = UIApplication.shared.delegate
                        self.window?.rootViewController = vc
                        self.window?.makeKeyAndVisible()
                    }
                }
            }
        }
        
        
//        if let aps = userInfo["aps"] as? [String:Any] {
//            if(userInfo["gcm.notification.type"] as! String == "3")
//            {
//                let ns = UserDefaults.standard
//                ns.setValue("3", forKey: "notificationType")
//                ns.synchronize()
//            }
//            else
//            {
//                let ns = UserDefaults.standard
//                ns.setValue("1", forKey: "notificationType")
//                ns.synchronize()
//            }
//        }
        //completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey]
        {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        let state = UIApplication.shared.applicationState
        print(state)
        if(state == .background){
            print("background")
        }
        if(state == .active){
            print("active")
        }
        if(state == .inactive){
            print("inactive")
        }

//        if state == .inactive  {
        
        NotificationCenter.default.post(name: NSNotification.Name("UpdateChat"), object: nil)

        
            if let aps = userInfo["aps"] as? [String:Any] {
                if(userInfo["gcm.notification.type"] as! String == "3")
                {
                    
                    let ns = UserDefaults.standard
                    ns.setValue("3", forKey: "notificationType")
                    ns.synchronize()
                    
                    let vcChat : ChatsTableVC = AppDelegate.storyboard.instanceVC()
                    let vc : SAMainTabbar = AppDelegate.storyboard.instanceVC()
                    vc.selectedIndex = 4
                    
                    self.window?.rootViewController = vc
                    self.window?.makeKeyAndVisible()
                    self.mainRootNav?.pushViewController(vcChat, animated: true)
                }
                else
                {
                    let ns = UserDefaults.standard
                    ns.setValue("1", forKey: "notificationType")
                    ns.synchronize()
                    
                    let vc : SAMainTabbar = AppDelegate.storyboard.instanceVC()
                    vc.selectedIndex = 2
                    
                    let appDelegate = UIApplication.shared.delegate
                    self.window?.rootViewController = vc
                    self.window?.makeKeyAndVisible()
                }
             }
        // completionHandler()
    }
}
// [END ios_10_message_handling]
extension AppDelegate : MessagingDelegate {

    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        Messaging.messaging().subscribe(toTopic: "/topics/e3omal")

        if InstanceID.instanceID().token() != nil
        {
            let fcmToken = InstanceID.instanceID().token() as! String
            UserDefaults.standard.setValue(fcmToken, forKey: "deviceToken")
            print(fcmToken)
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
//        Messaging.messaging().subscribe(toTopic: "/topics/testTopic")

        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        
        UserDefaults.standard.setValue(fcmToken, forKey: "deviceToken")
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage)
    {
        
    }
}
