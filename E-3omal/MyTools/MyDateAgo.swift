//
//  MyDateAgo.swift
//
//
//  Created by ibra on 10/23/16.
//  Copyright © 2016 ibra. All rights reserved.
//

import Foundation
extension DateFormatter {

    func timeSince(from: Date, numericDates: Bool = false) -> String {
        let calendar = Calendar.current
        let now = NSDate()
        let earliest = now.earlierDate(from as Date)
        let latest = earliest == now as Date ? from : now as Date
        let components = calendar.dateComponents([.year, .weekOfYear, .month, .day, .hour, .minute, .second], from: earliest, to: latest as Date)
        
        var result = ""
        
        if components.year! >= 2 {
            result = " منذ \(components.year!) سنوات"
        } else if components.year! >= 1 {
            if numericDates {
                result = "منذ سنة"
            } else {
                result = "منذ سنة"
            }
        } else if components.month! >= 2 {
            result = " منذ \(components.month!) أشهر"
        } else if components.month! >= 1 {
            if numericDates {
                result = "منذ شهر"
            } else {
                result = "منذ شهر"
            }
        } else if components.weekOfYear! >= 2 {
            result = " منذ \(components.weekOfYear!) أسابيع"
        } else if components.weekOfYear! >= 1 {
            if numericDates {
                result = "منذ أسبوع"
            } else {
                result = "منذ أسبوع"
            }
        } else if components.day! >= 2 {
            result = " منذ \(components.day!) أيام"
        } else if components.day! >= 1 {
            if numericDates {
                result = "منذ يوم"
            } else {
                result = "منذ يوم"
            }
        } else if components.hour! >= 2 {
            result = " منذ \(components.hour!) ساعات"
        } else if components.hour! >= 1 {
            if numericDates {
                result = "منذ ساعة"
            } else {
                result = "منذ ساعة"
            }
        } else if components.minute! >= 2 {
            result = " منذ \(components.minute!) دقائق"
        } else if components.minute! >= 1 {
            if numericDates {
                result = "منذ دقيقة"
            } else {
                result = "منذ دقيقة"
            }
        } else if components.second! >= 3 {
            result = " منذ \(components.second!) ثواني"
        } else {
            result = "الان"
        }
        
        return result
    }
}
