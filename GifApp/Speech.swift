//
//  Speech.swift
//  GifApp
//
//  Created by 朱坤 on 11/26/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

let speechAPI = Config.baseUrl + "/api/v1/activities/663b2c7b-14c9-48bc-abaa-7810c6073168/speeches"
class Speech{
  let id: String
  let title: String?
  let description: String?
  let start_at: String?
  let end_at: String?
  let theme: String?
  var guest: Guest?
  
  private let TAG = _stdlib_getDemangledTypeName(Speech.self)
  var isCollected: Bool {
    get {
      return LocalStorage.arrayContains(TAG, value: id)
    }
    set{
      if newValue && !LocalStorage.arrayContains(TAG, value: id){
        LocalStorage.arrayAppend(TAG, value: id)
      }
      if !newValue && LocalStorage.arrayContains(TAG, value: id){
        LocalStorage.removeFromArray(TAG,value: id)
      }
    }
  }
  
  init(id: String, title: String?, description: String?, start_at: String?, end_at: String?, theme: String?){
    self.id = id
    self.title = title
    self.description = description
    self.start_at = start_at
    self.end_at = end_at
    self.theme = theme
  }
  
  func start_at_after_fomat(form: String) -> String{
    let fomat = NSDateFormatter()
    fomat.dateFormat = form
    let start = fomat.stringFromDate(NSDate(timeIntervalSince1970: Double(start_at!)!))
    return start
  }
  
  func getDateHour() -> Int{
    let components = getComponent(start_at)
    return components.hour
  }
  
  func getDateDay() -> Int{
    let components = getComponent(start_at)
    return components.day
  }
  
  private func getComponent(time: String?) -> NSDateComponents{
    var date = NSDate(timeIntervalSince1970: Double("0")!)
    let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
    if let start = time{
      date = NSDate(timeIntervalSince1970: Double(start)!)
    }
    return calendar.components([.Month, .Day, .Hour, .Minute], fromDate: date)
  }
  
//  static func split(speeches: [Speech]) -> [[Speech]]{
//    var result = [[Speech]]()
//    var key = [String]()
//    for speech in speeches {
//      if let theme = speech.theme {
//        if let index = key.indexOf(theme){
//          result[index].append(speech)
//        } else {
//          key.append(theme)
//          result.append([speech])
//        }
//      }
//    }
//    return result
//  }
  
  static func split(speeches: [Speech]) -> [[Speech]]{
    var amSpeeches = [Speech]()
    var pmSpeeches = [Speech]()
    for speech in speeches {
      if speech.getDateHour() > 12{
        pmSpeeches.append(speech)
      } else {
        amSpeeches.append(speech)
      }
    }
    return [amSpeeches, pmSpeeches]
  }
  
  static func getData(callback: (success: Bool, speeches: [[Speech]]?)->()){
    Alamofire.request(.GET, speechAPI).response{ request, response, data, error in
      let speechData = JSON(data: data!)["speeches"].array
      let speeches = speechData!.map{ speech-> Speech in
        return getSpeech(speech)
      }
      if error != nil{
        callback(success: false, speeches: nil)
      } else {
        callback(success: true, speeches: splitByDay(speeches))
      }
    }
  }
  
  static func getSpeech(speech: JSON) -> Speech{
    let sp = Speech(id: speech["id"].string!, title: speech["title"].string, description: speech["description"].string, start_at: speech["start_at"].string, end_at: speech["end_at"].string, theme: speech["theme"].string)
    if speech["guest"] != nil {
      sp.guest = Guest.getGuest(speech["guest"])
    }
    return sp
  }
  
  static func splitByDay(speeches: [Speech]) -> [[Speech]]{
    var temp_result = [Int: [Speech]]()
    for speech in speeches{
      let day = speech.getDateDay()
      if temp_result[day] == nil{ temp_result[day] = []}
      temp_result[day]!.append(speech)
    }
    var result = [[Speech]]()
    let sort_result = temp_result.sort { $0.0 < $1.0 }
    result = sort_result.map{ _, value in
      return value
    }
    return result
  }
  
  static func getCollectedSpeech(callback:( Bool,[Speech]?)->() ) -> ()  {
    Alamofire.request(.GET, speechAPI).response{ request, response, data, error in
      if HttpUtils.isSuccess(response) {
        let speechData = JSON(data: data!)["speeches"].array
        let speeches = speechData!.map{ speech-> Speech in
          return getSpeech(speech)
        }
        let result = speeches.filter { speech in
          speech.isCollected
        }
        callback(true,result)
      }else{
        callback(false,[])
      }
    }
  }
  
  
  static func find_by_id(speech_id: String) -> Speech{
    return Speech(id: "", title: "", description: "'", start_at: "", end_at: "", theme: "")
  }
  
}