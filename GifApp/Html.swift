//
//  html.swift
//  GifApp
//
//  Created by 朱坤 on 1/1/16.
//  Copyright © 2016 Zkuns. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

let aboutHtmlURL = "http://events.geekpark.net/about_gif.html"
class Html {
  
  static func loadLocalHtmlString(callback: (String)->()){
    if let str = LocalStorage.getString(AboutConfig.aboutHtmlKey){
      callback(str)
    }
  }
  
  static func loadHtmlStringFromInternet(callback: (String?)->()){
    Alamofire.request(.GET, aboutHtmlURL).response{ request, response, data, error in
      if HttpUtils.isSuccess(response){
        let str = String(data: data!, encoding: NSUTF8StringEncoding)
        callback(str)
      } else {
        callback(nil)
      }
    }
  }
  
  static func storeString(str: String){
    LocalStorage.setString(AboutConfig.aboutHtmlKey, value: str)
  }
}