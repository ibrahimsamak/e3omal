//
//  MyApi.swift
//  
//
//  Created by ibra on 10/12/16.
//  Copyright © 2016 ibra. All rights reserved.
//

import Foundation
import Alamofire

class MyApi
{
    static let api = MyApi()
    
    static public var apiMainURL = "http://demo.e-3omal.com/api/" as String
    static public var PhotoURL = "http://demo.e-3omal.com/" as String
    
    enum userType :String {
        case customer   = "customer"
        case contractor = "contractor"
        case handyman   = "handyman"
    }
    
    func PostEditUser(name:String,email:String ,mobile:String,image:Data,
                      civil_id:String,images:[UIImage],is_24:String,video:Data , company_name:String,category_id:[Int], completion:((DataResponse<Any>,Error?)->Void)!) {
        let headers: HTTPHeaders =
            [
                "Accept": "application/json",
                "Accept-Language" :  MyTools.tools.getMyLang(),
                "Authorization" :  MyTools.tools.getMyToken(),
            ]
        
        Alamofire.upload(
            multipartFormData:
            {
                multipartFormData in
                
                multipartFormData.append(image, withName: "profile_image",fileName: "img.png", mimeType: "image/png")
                
                multipartFormData.append(name.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "name")
                
                multipartFormData.append(mobile.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "mobile")
                
                
                multipartFormData.append(email.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "email")
                
                multipartFormData.append("1".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "device_type")
                
//                multipartFormData.append(FCM_token.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "token")
                
                if(MyTools.tools.getUserType() == "contractor" || MyTools.tools.getUserType()  == "handyman")
                {
//                    var myData = category_id.withUnsafeBufferPointer {Data(buffer: $0)}
//                    multipartFormData.append(myData, withName: "category_id")
                    
                    multipartFormData.append("\(category_id)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "category_id")

                    
                    for index in 0..<images.count
                    {
                        let image = UIImageJPEGRepresentation(images[index], 0.8) as? Data
                        let name = "images["+String(index)+"]"
                        multipartFormData.append(image!, withName: name,fileName: "img.png", mimeType: "image/png")
                    }
                    
                    multipartFormData.append(video, withName: "video",fileName: "video.mp4", mimeType: "video/mp4")
                }
                
                if(MyTools.tools.getUserType() == "contractor")
                {
                    multipartFormData.append(company_name.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "company_name")
                    multipartFormData.append(civil_id.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "civil_id")
                }
                
                if(MyTools.tools.getUserType() == "handyman")
                {
                    multipartFormData.append(is_24.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "is_24")
                }
        },
            to: String(format:"%@%@",MyApi.apiMainURL,"user/update"),
            headers:headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if(response.result.isSuccess)
                        {
                            completion(response,nil)
                        }
                        else
                        {
                            completion(response,response.result.error)
                        }
                    }
                case .failure(_): break
                }
        })
    }
    
    
    func PostSignUpNewUser(name:String,email:String ,mobile:String , password :String , type:String,is_24:String , company_name:String,category_id:[Int] , profile_image:Data , civil_id:String,images:[UIImage],token:String ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang()
        ]
        
        Alamofire.upload(
            multipartFormData:
            {
                multipartFormData in
                
//                var myData = category_id.withUnsafeBufferPointer {Data(buffer: $0)}

                
                multipartFormData.append(profile_image, withName: "profile_image",fileName: "img.png", mimeType: "image/png")
                
                multipartFormData.append(name.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "name")
                
                multipartFormData.append(email.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "email")
                
                multipartFormData.append(mobile.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "mobile")
                
                multipartFormData.append(password.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "password")
                
                multipartFormData.append(type.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "type")
                
                if(type == "contractor" || type == "handyman")
                {
//                    multipartFormData.append(myData, withName: "category_id")
                    multipartFormData.append("\(category_id)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "category_id")

                    for index in 0..<images.count
                    {
                        let image = UIImageJPEGRepresentation(images[index], 0.8) as? Data
                        let name = "images["+String(index)+"]"
                        multipartFormData.append(image!, withName: name,fileName: "img.png", mimeType: "image/png")
                    }
                }
                if(type == "contractor")
                {
                    multipartFormData.append(company_name.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "company_name")
                    multipartFormData.append(civil_id.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "civil_id")
                }
                if(type == "handyman")
                {
                    multipartFormData.append(is_24.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "is_24")
                }
                
                multipartFormData.append("\(1)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "device_type")
                
                multipartFormData.append(token.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "token")
                
                
        },
            to: String(format:"%@%@",MyApi.apiMainURL,"user"),
            headers:headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if(response.result.isSuccess)
                        {
                            completion(response,nil)
                        }
                        else
                        {
                            completion(response,response.result.error)
                        }
                    }
                case .failure(_): break
                }
        })
    }
    
    
    func PostUpdateUser(name:String,email:String ,mobile:String ,is_24:String , company_name:String,category_id:[Int] , profile_image:Data ,images:[Data],token:String,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization" :  MyTools.tools.getMyToken(),
            "Accept-Language" :  MyTools.tools.getMyLang()
        ]
        
        Alamofire.upload(
            multipartFormData:
            {
                multipartFormData in
                
                var myData = category_id.withUnsafeBufferPointer {Data(buffer: $0)}
                
                multipartFormData.append(token.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "token")
                
                multipartFormData.append(profile_image, withName: "profile_image",fileName: "img.png", mimeType: "image/png")
                
                multipartFormData.append(name.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "name")
                
                multipartFormData.append(email.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "email")
                
                multipartFormData.append(mobile.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "mobile")
                
                multipartFormData.append(company_name.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "company_name")
                
                multipartFormData.append(myData, withName: "category_id")
                
                multipartFormData.append(images[0], withName: "images[0]",fileName: "img.png", mimeType: "image/png")
                
                multipartFormData.append(is_24.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "is_24")
                
                multipartFormData.append("\(1)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "device_type")
                
                
        },
            to: String(format:"%@%@",MyApi.apiMainURL,"user/update"),
            headers:headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if(response.result.isSuccess)
                        {
                            completion(response,nil)
                        }
                        else
                        {
                            completion(response,response.result.error)
                        }
                    }
                case .failure(_): break
                }
        })
    }
    
    func Postlogout(token:String,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  MyTools.tools.getMyToken(),
            ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"user/logout"), method: .post, parameters:["token":token , "device_type":1],encoding: JSONEncoding.default , headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    func PostSendNotification(customer_id:String,message:String,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  MyTools.tools.getMyToken(),
            ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"user/notifications"), method: .post, parameters:["customer_id":customer_id , "message":message],encoding: JSONEncoding.default , headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    func PostNotifications(notification_status:Int,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  MyTools.tools.getMyToken(),
            ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"user/notificationStatus"), method: .post, parameters:["notification_status":notification_status],encoding: JSONEncoding.default , headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func PostLoginUser(email:String ,password:String , token:String ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"user/login"), method: .post,
                          parameters:["email":email , "password":password , "token":token , "device_type":1],encoding: JSONEncoding.default , headers:headers).responseJSON { response in
                            if(response.result.isSuccess)
                            {
                                completion(response,nil)
                            }
                            else
                            {
                                completion(response,response.result.error)
                            }
        }
    }

    
    func postPayment(amount:String,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  MyTools.tools.getMyToken(),
            
            ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"user/payment"), method: .post,
                          parameters:["amount":amount],encoding: JSONEncoding.default , headers:headers).responseJSON { response in
                            if(response.result.isSuccess)
                            {
                                completion(response,nil)
                            }
                            else
                            {
                                completion(response,response.result.error)
                            }
        }
    }
    
    //
    func postAcceptorRejectByHandyMan(job_id:Int,offer_id:Int ,status:String ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  MyTools.tools.getMyToken(),
            
            ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"offer/WorkerResponse"), method: .post,
                          parameters:["job_id":job_id , "offer_id":offer_id , "status":status],encoding: JSONEncoding.default , headers:headers).responseJSON { response in
                            if(response.result.isSuccess)
                            {
                                completion(response,nil)
                            }
                            else
                            {
                                completion(response,response.result.error)
                            }
        }
    }
    
    //offer/CustomerResponse
    func postAcceptorRejectBbCustomer(job_id:Int,offer_id:Int ,status:String ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  MyTools.tools.getMyToken(),
            
            ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"offer/CustomerResponse"), method: .post,
                          parameters:["job_id":job_id , "offer_id":offer_id , "status":status],encoding: JSONEncoding.default , headers:headers).responseJSON { response in
                            if(response.result.isSuccess)
                            {
                                completion(response,nil)
                            }
                            else
                            {
                                completion(response,response.result.error)
                            }
        }
    }
    
    
    func PostRate(provider_id:Int ,rate:Int ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  MyTools.tools.getMyToken(),
            
            ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"offer/rate"), method: .post,
                          parameters:["provider_id":provider_id , "rate":rate],encoding: JSONEncoding.default , headers:headers).responseJSON { response in
                            if(response.result.isSuccess)
                            {
                                completion(response,nil)
                            }
                            else
                            {
                                completion(response,response.result.error)
                            }
        }
    }
    

    func PostPayment(amount:String,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  MyTools.tools.getMyToken(),
            
            ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"user/payment"), method: .post,
                          parameters:["amount":amount],encoding: JSONEncoding.default , headers:headers).responseJSON { response in
                            if(response.result.isSuccess)
                            {
                                completion(response,nil)
                            }
                            else
                            {
                                completion(response,response.result.error)
                            }
        }
    }
    
    func PostMakeOffer(job_id:Int ,budget:Int ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  MyTools.tools.getMyToken(),
            ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"offer"), method: .post,
                          parameters:["job_id":job_id , "budget":budget],encoding: JSONEncoding.default , headers:headers).responseJSON { response in
                            if(response.result.isSuccess)
                            {
                                completion(response,nil)
                            }
                            else
                            {
                                completion(response,response.result.error)
                            }
        }
    }
    
    
    
    func PostChangePassword(old_password:String , password:String ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization" :  MyTools.tools.getMyToken(),
            "Accept-Language" :  MyTools.tools.getMyLang()
        ]
        
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"changePassword"), method: .post,
                          parameters:["old_password":old_password , "password":password],encoding: JSONEncoding.default,headers:headers).responseJSON { response in
                            if(response.result.isSuccess)
                            {
                                completion(response,nil)
                            }
                            else
                            {
                                completion(response,response.result.error)
                            }
        }
    }
    
    func PostForgetPassword(email:String,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang()
        ]
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"password/email"), method: .post,parameters:["email":email],encoding: JSONEncoding.default,headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func PostCheckCode(code:String,mobile:String,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"user/checkCode"), method: .post,parameters:["code":code , "mobile":mobile],encoding: JSONEncoding.default,headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func PostRequestNewCode(code:String , mobile:String,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"user/requestNewCode"), method: .post,parameters:["code":code , "mobile":mobile],encoding: JSONEncoding.default,headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func PostupdatePassword(password:String ,password_confirmation:String ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization" :  MyTools.tools.getMyToken(),
            "Accept-Language" :  MyTools.tools.getMyLang()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"user/password"), method: .post,parameters:["password":password , "password_confirmation":password_confirmation],encoding: JSONEncoding.default,headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func PostCahngePassword(password:String ,password_confirmation:String ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang(),
            "Authorization" : MyTools.tools.getMyToken()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"user/password"), method: .post,parameters:["password_confirmation":password_confirmation , "password":password],encoding: JSONEncoding.default,headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    func PostSendToken(token:String ,type:String ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"user/token"), method: .post,parameters:["type":type , "token":token],encoding: JSONEncoding.default,headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func PostContact(name:String ,email:String , message:String, mobile:String ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"contact"), method: .post,parameters:["name":name , "email":email , "message":message , "mobile":mobile],encoding: JSONEncoding.default,headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    
    func DeleteImage(ID:String ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  MyTools.tools.getMyToken(),
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"user/deleteImage/"+ID), method: .post,encoding: JSONEncoding.default,headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    func GetUserProfile(completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accep": "application/json",
            "Authorization" :  MyTools.tools.getMyToken(),
            "Accept-Language" :  MyTools.tools.getMyLang()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"user"), method: .get,encoding: JSONEncoding.default , headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    func GetProviderProfile(userId:String, completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accep": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  MyTools.tools.getMyToken()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"user/"+userId), method: .get,encoding: JSONEncoding.default , headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    func GetDeduction(completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  MyTools.tools.getMyToken()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"user/deduction"), method: .get,encoding: JSONEncoding.default ,headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func GetNotificationList(completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  MyTools.tools.getMyToken()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"user/notifications"), method: .get,encoding: JSONEncoding.default ,headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func GetCharge(completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  MyTools.tools.getMyToken()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"user/charge"), method: .get,encoding: JSONEncoding.default ,headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func GetCategories(completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"categories"), method: .get,encoding: JSONEncoding.default ,headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    func GetTerms(completion:((DataResponse<Any>,Error?)->Void)!)
    {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang()
            ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"terms"), method: .get,encoding: JSONEncoding.default,headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func GetConfig(completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"getConfig"), method: .get,encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func GetAbout(completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang()
        ]
      
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"about"), method: .get,encoding: JSONEncoding.default,headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func GetPrivacy(completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"privacy"), method: .get,encoding: JSONEncoding.default,headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    func GetAds(completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"ad"), method: .get,encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func GetJobs(page:String ,title:String,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  MyTools.tools.getMyToken()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"job?page="+page+"&title="+title), method: .get,encoding: JSONEncoding.default , headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func PostNewJob(title_en:String,details_en:String ,address_en:String ,title_ar:String,details_ar:String ,address_ar:String, lat :Double , lan:Double,budget:Int , building_material:Int,category_id:Int , image:Data ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  MyTools.tools.getMyToken()
        ]
        
        Alamofire.upload(
            multipartFormData:
            {
                multipartFormData in
                multipartFormData.append(title_en.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "title_en")
                
                multipartFormData.append(details_en.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "details_en")
                
                multipartFormData.append(address_en.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "address_en")
                
                multipartFormData.append(title_ar.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "title_ar")
                
                multipartFormData.append(details_ar.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "details_ar")
                
                multipartFormData.append(address_ar.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "address_ar")
                
                multipartFormData.append("\(lat)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "lat")
                
                multipartFormData.append("\(lan)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "lan")
                
                multipartFormData.append("\(budget)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "budget")
                
                multipartFormData.append("\(category_id)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "category_id")
                
                multipartFormData.append("\(building_material)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "building_material")
                
                multipartFormData.append(image, withName: "image",fileName: "img.png", mimeType: "image/png")
                
        },
            to: String(format:"%@%@",MyApi.apiMainURL,"job"),
            headers:headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if(response.result.isSuccess)
                        {
                            completion(response,nil)
                        }
                        else
                        {
                            completion(response,response.result.error)
                        }
                    }
                case .failure(_): break
                }
        })
    }
}
