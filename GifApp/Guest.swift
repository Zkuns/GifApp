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

let guestAPI = Config.baseUrl + "/api/v1/activities/663b2c7b-14c9-48bc-abaa-7810c6073168/guests"
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
  
  static func getData(callback: (success: Bool, guests: [(String,[Guest])]?)->()){
    Alamofire.request(.GET, guestAPI).response{ request, response, data, error in
      let guests = JSON(data: data!)["guests"].array
      let result = guests!.map{ guest -> Guest in
        return getGuest(guest)
      }
      if (error != nil){
        callback(success: false, guests: nil)
      } else {
        callback(success: true, guests: splitByFirstChar(result))
      }
    }
  }
  
  private func getFirstChar() -> String{
    let name: NSMutableString = NSMutableString(string: self.name!)
    CFStringTransform(name, nil, kCFStringTransformMandarinLatin, false)
    CFStringTransform(name, nil, kCFStringTransformStripDiacritics, false);
    let char = name as String
    return String(char[char.startIndex]).uppercaseString
  }
  
  private static func splitByFirstChar(guests: [Guest]) -> [(String, [Guest])]{
    let azchar = Array("abcedfghijklmnopqrstuvwxyz".characters)
    let azstr = azchar.map{ return String($0).uppercaseString }
    var result = [String: [Guest]]()
    azstr.map{ str in
      result[str] = []
    }
    for guest in guests{
      let char = guest.getFirstChar()
      result[char]?.append(guest)
    }
    let sort_result = result.sort{ $0.0 < $1.0 }
    return sort_result
  }
  
}