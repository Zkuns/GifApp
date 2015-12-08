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
    let timeAfterFomat = fomat.stringFromDate(NSDate(timeIntervalSince1970: Double(time!)!))
    return timeAfterFomat
  }
}