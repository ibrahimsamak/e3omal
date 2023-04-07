//
//  Language.swift
//  localizeExample
//
//  Created by Mostafa on 4/28/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import Foundation

class Language{
    
    class func currentLanguage() -> String
    {
        let ns = UserDefaults.standard
        let langs = ns.value(forKey: "AppleLanguages") as! NSArray
        let firstLang = langs.firstObject as! String
        
        return firstLang
    }
    
    class func setAppLanguage(lang:String)
    {
        let ns = UserDefaults.standard
        ns.setValue([lang, currentLanguage()], forKey: "AppleLanguages")
        ns.synchronize()
    }
}
