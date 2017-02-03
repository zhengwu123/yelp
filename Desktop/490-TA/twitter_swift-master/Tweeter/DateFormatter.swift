//
//  DateFormatter.swift
//  Tweeter
//
//  Created by zheng wu on 2/11/16.
//  Copyright © 2016 zheng wu. All rights reserved.
//

import UIKit

class DateFormatter: NSObject {
    class var sharedInstance: Foundation.DateFormatter {
        struct Static {
            static let instance = Foundation.DateFormatter()
        }
        return Static.instance
    }
    
    class func dateFromString(_ dateString: String?) -> Date? {
        
        sharedInstance.dateFormat = "EEE MMM d HH:mm:ss Z y"
        var calendar = Calendar.autoupdatingCurrent
        calendar.timeZone = TimeZone.current
        sharedInstance.timeZone = calendar.timeZone
        return sharedInstance.date(from: dateString!)
    }
    
    class func sinceNowFormat(_ startDate: Date?) -> String? {
        if startDate == nil {
            return nil
        }
        
        var outputTime = ""
        let calendar = Calendar.autoupdatingCurrent
        let components = (calendar as NSCalendar).components([.year, .month, .day, .hour, .minute, .second], from: startDate!, to: Date(), options: [])
        
        if components.year! > 1 {
            outputTime = "\(components.year) years ago"
        } else if components.month! > 1 {
            outputTime = "\(components.month) months ago"
        } else if components.day! > 1 {
            outputTime = "\(components.day) days ago"
        } else if components.hour! > 1 {
            outputTime = "\(components.hour)h"
        } else if components.minute! > 1 {
            outputTime = "\(components.minute)m"
        } else {
            outputTime = "\(components.second)s"
        }
        return outputTime
    }

}

