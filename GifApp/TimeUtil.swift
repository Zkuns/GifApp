//
//  TimeUtil.swift
//  GifApp
//
//  Created by 朱坤 on 12/8/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import Foundation

class TimeUtil{
  static func fomatTime(time: String?, form: String) -> String{
    let fomat = NSDateFormatter()
    fomat.dateFormat = form
    let timeAfterFomat = fomat.stringFromDate(NSDate(timeIntervalSince1970: Double(time ?? "0")!))
    return timeAfterFomat
  }
  
  static func timeAgo(time: String?) -> String{
    let date = NSDate(timeIntervalSince1970: Double(time ?? "0")!)
    return date.timeAgo
  }
}

extension NSDate{
  
  public var timeAgo: String{
    let components = self.dateComponents()
    if components.year > 0 {
      return "\(components.year)年之前"
    }
    if components.month > 0 {
      return "\(components.month)月之前"
    }
    if components.day > 0 {
      return "\(components.day)天之前"
    }
    if components.hour > 0 {
      return "\(components.hour)小时之前"
    }
    if components.minute > 0 {
      return "\(components.minute)分钟之前"
    }
    return "\(components.second)秒之前"
  }
  
  
  private func dateComponents() -> NSDateComponents {
    let calander = NSCalendar.currentCalendar()
    return calander.components([.Second, .Minute, .Hour, .Day, .Month, .Year], fromDate: self, toDate: NSDate(), options: [])
  }
  
}


