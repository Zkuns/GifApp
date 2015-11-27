//
//  Guest.swift
//  GifApp
//
//  Created by 朱坤 on 11/26/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Guest{
  let name: String?
  let company: String?
  let title: String?
  let avator: String?
  
  var speech: Speech?
  
  init(name: String?, company: String?, title: String?, avator: String?){
    self.name = name
    self.company = company
    self.title = title
    self.avator = avator
  }
  
  static func getGuest(guest: JSON) -> Guest{
    let gu = Guest(name: guest["name"].string, company: guest["company"].string, title: guest["title"].string, avator: guest["avator"].string)
    if guest["speech"] != nil{
      gu.speech = Speech.getSpeech(guest["speech"])
    }
    return gu
  }
}