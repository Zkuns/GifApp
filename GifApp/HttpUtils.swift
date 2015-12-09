//
//  HttpUtils.swift
//  GifApp
//
//  Created by ScorpiusZ on 15/12/9.
//  Copyright © 2015年 Zkuns. All rights reserved.
//

import Foundation

class HttpUtils {
  
  static func isSuccess(response: NSHTTPURLResponse?) -> Bool {
    let statusCode = response?.statusCode ?? -1
    return statusCode >= 200 && statusCode < 400
  }
}
