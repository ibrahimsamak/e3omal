//  MyTools.swift
//
//  Created by ibra on 10/13/16.
//  Copyright © 2016 ibra. All rights reserved.
//

import Foundation
//import ARSLineProgress
import SystemConfiguration
import AVFoundation
import AVKit

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):    return l < r
    case (nil, _?):        return true
    default:            return false
    }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):    return l >= r
    default:            return !(lhs < rhs)
    }
}



class MyTools{
    
    static var tools = MyTools()

    func convertDateToString(_ date: Date) -> String {
        let formater = DateFormatter()
        formater.locale = NSLocale(localeIdentifier: "en") as Locale!
        formater.dateFormat = "d' 'MMMM' 'yyyy'"
        return formater.string(from: date)
    }
    
    
    func GetDateAgo(dt_date : Date ) -> String
    {
        //        let dateString = dt_date
        let dateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        let s = dt_date
        let retdate = dateFormatter.timeSince(from: s, numericDates: true)
        return retdate
    }
    
    
    
    func appFont(size:CGFloat) -> UIFont {
        let font = UIFont(name: "beINNormal", size: size)!
        return font
    }

    
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    
    func alertWithOKButton(Title: String , Message: String , buttonName: String )->UIAlertController
    {
        let alertController = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: buttonName, style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
        }
        alertController.addAction(okAction)
        return alertController
    }
    func GetImageFromUrl(Url:String) -> UIImage {
        let url = NSURL(string: Url) as! URL
        let Image = NSData(contentsOf: url) as! Data
        let img : UIImage = UIImage(data: Image)!
        
        return img
    }
    
    func getMyLang() -> String
    {
        if(Language.currentLanguage() != "ar"){
            let index = Language.currentLanguage().index(Language.currentLanguage().startIndex, offsetBy: 2)
            let mySubstring = Language.currentLanguage().prefix(upTo: index)
            return String(mySubstring)
        }
        else
        {
            return "ar"
        }
    }
    
    
    func filterStringNull(txt: Any) -> String {
        let str = "\(txt)"
        if (str.isEmpty) {
            return ""
        }
        if str.isEqual(nil)  {
            return ""
        }
        if (str == "(null)") {
            return ""
        }
        if (str == "(NULL)") {
            return ""
        }
        if (str == "null") {
            return ""
        }
        if str.isEqual(NSNull()) {
            return ""
        }
        return str.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    
    func connectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
        
    }
    
    func dateFromStringConverter(date: String)-> NSDate?
    {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        //Specify Format of String to Parse
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" //or you can use "yyyy-MM-dd'T'HH:mm:ssX"
        //Parse into NSDate
        let dateFromString : NSDate = dateFormatter.date(from: date)! as NSDate
        
        return dateFromString
    }
    
    func getMyKey(_ Key:String) -> String
    {
        let ns = UserDefaults.standard
        let dict = ns.value(forKey: "CurrentUser") as! NSDictionary
        let Key = dict.value(forKey: Key) as! String
        return Key
    }
    
    
    func getMyId() -> String
    {
        let ns = UserDefaults.standard
        let dict = ns.value(forKey: "CurrentUser") as! NSDictionary
        let id = dict.value(forKey: "id") as! Int
        return String(id)
    }
    
    func getMyToken() -> String
    {
        let ns = UserDefaults.standard
        let dict = ns.value(forKey: "CurrentUser") as! NSDictionary
        let access_token = dict.value(forKey: "access_token") as! String
        return access_token
    }
    
    func getUserType() -> String
    {
        let ns = UserDefaults.standard
        let dict = ns.value(forKey: "CurrentUser") as! NSDictionary
        let type = dict.value(forKey: "type") as! String
        return type
    }
    
    func getConfigString(_ key:String) -> String
    {
        let ns = UserDefaults.standard
        let key = ns.value(forKey: key) as! String
        return key
    }
    
    func getConfigFloat(_ key:String) -> Float
    {
        let ns = UserDefaults.standard
        let key = ns.value(forKey: key) as! Float
        return key
    }
  
    
//    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
//        URLSession.shared.dataTask(with: url) {
//            (data, response, error) in
//            completion(data, response, error)
//            }.resume()
//    }
    
    func colorWithHexString (_ hexStr:String) -> UIColor {
        
        let hex = hexStr.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return .clear
        }
        return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
        
    }
    
    func getDeviceToken() -> String? {
        
        let ns = UserDefaults.standard
        let deviceToken = ns.value(forKey: "deviceToken") as? String ?? ""
        return deviceToken
    }
    
    
    func isStudent(b_student:String) -> Bool{
        let ns = UserDefaults.standard
        let dict = ns.value(forKey: "CurrentUser") as! NSDictionary
        let isStudent = dict.value(forKey: b_student) as! Bool
        return isStudent
    }
    
    func openAdvLink(myUrl:String)
    {
        let url = NSURL(string: myUrl)! as URL
        UIApplication.shared.openURL(url)
    }
    
    
    
    func convertDateFormater2(date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        //dateFormatter.timeZone = NSTimeZone(name: "UTC")
        
        guard let date = dateFormatter.date(from: date) else {
            assert(false, "no date from string")
            return ""
        }
        //2017-08-08T19:58:15.16
        dateFormatter.dateFormat = "yyyy/MM/dd"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let timeStamp = dateFormatter.string(from: date)
        
        return timeStamp
    }
    
    
    func convertDateToTime(date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //dateFormatter.timeZone = NSTimeZone(name: "UTC")
        
        guard let date = dateFormatter.date(from: date) else {
            assert(false, "no date from string")
            return ""
        }
        //2017-08-08T19:58:15.16
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let timeStamp = dateFormatter.string(from: date)
        
        return timeStamp
    }
    
    
    
    func convertDateFormater(date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //dateFormatter.timeZone = NSTimeZone(name: "UTC")
        
        guard let date = dateFormatter.date(from: date) else {
            assert(false, "no date from string")
            return ""
        }
        //2017-08-08T19:58:15.16
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let timeStamp = dateFormatter.string(from: date)
        
        return timeStamp
    }
    
    func convertDateFormater2(date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let convertedDateString = dateFormatter.string(from: date)
        let ConDate = convertedDateString as String
        
        print("date3\(ConDate)") //July 25 2016
        return ConDate
        
    }
    
    func GetDateAgo(dt_date : String ) -> String
    {
        let dateString = dt_date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        let s = dateFormatter.date(from: dateString)
        let retdate = dateFormatter.timeSince(from: s!, numericDates: true)
        return retdate
    }
    
    func videoSnapshot(filePathLocal: NSString) -> UIImage? {
        
        let vidURL = NSURL(fileURLWithPath:filePathLocal as String)
        let asset = AVURLAsset(url: vidURL as URL)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        
        let timestamp = CMTime(seconds: 1, preferredTimescale: 60)
        
        do {
            let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
            return UIImage(cgImage: imageRef)
        }
        catch let error as NSError
        {
            print("Image generation failed with error \(error)")
            return nil
        }
    }
    
    func ReplaceSpaceWithPercentage(text:String) -> String {
        
        
        var originalString = text
        let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        return escapedString!
    }
    

}

