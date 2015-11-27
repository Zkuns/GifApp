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

class Speech{
  let title: String?
  let description: String?
  let start_at: String?
  let end_at: String?
  let theme: String?
  var guest: Guest?
  
  init(title: String?, description: String?, start_at: String?, end_at: String?, theme: String?){
    self.title = title
    self.description = description
    self.start_at = start_at
    self.end_at = end_at
    self.theme = theme
  }
  
  func duration() -> String{
    let format = NSDateFormatter()
    format.dateFormat = "HH:mm"
    let start = format.stringFromDate(NSDate(timeIntervalSince1970: Double(start_at!)!))
    let end = format.stringFromDate(NSDate(timeIntervalSince1970: Double(end_at!)!))
    return start + "-" + end
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
  
  static func getData(controller: SpeechViewController){
    Alamofire.request(.GET, Config.speechesAPI).response{ request, response, data, error in
      let speechData = JSON(data: data!)["speeches"].array
      let speeches = speechData!.map{ speech-> Speech in
        return getSpeech(speech)
      }
      controller.speeches = splitByDay(speeches)
      print(speeches)
    }
  }
  
  static func getSpeech(speech: JSON) -> Speech{
    let sp = Speech(title: speech["title"].string, description: speech["description"].string, start_at: speech["start_at"].string, end_at: speech["end_at"].string, theme: speech["theme"].string)
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
  
  static func getCurrentData(speeches: [Speech]?, day: Day) -> [Speech]?{
    if (speeches != nil) {
      let result = Speech.splitByDay(speeches!)
      switch day{
      case .First: return result[0]
      case .Second: return result[1]
      case .Third: return result[2]
      }
    }
    return []
  }
}