//
//  LocalStorage.swift
//  GifApp
//
//  Created by ScorpiusZ on 15/12/7.
//  Copyright © 2015年 Zkuns. All rights reserved.
//

import Foundation

class LocalStorage {
  
  static private let userDefaults = NSUserDefaults.standardUserDefaults()
  
  static func getString(key: String) -> String? {
    return userDefaults.stringForKey(key)
  }
  
  static func setString(key: String, value: String?) {
    userDefaults.setObject(value, forKey: key)
  }
  
  static func arrayAppend(key: String, value: AnyObject) -> [AnyObject] {
    let result = (userDefaults.arrayForKey(key) ?? []) + [value]
    userDefaults.setObject(result, forKey: key)
    return result
  }
  
  static func arrayContains(key: String, value: AnyObject) -> Bool {
    let array = userDefaults.arrayForKey(key) ?? [] as NSArray
    return array.containsObject(value)
  }
  
  static func removeFromArray(key: String, value: AnyObject) {
    if var array = userDefaults.arrayForKey(key){
      let index = (array as NSArray).indexOfObject(value)
      array.removeAtIndex(index)
      userDefaults.setObject(array, forKey: key)
    }
  }
  
  static func setNSData(key: String, value: NSData?) {
    userDefaults.setObject(value, forKey: key)
  }
  
  static func getNSdata(key: String) -> NSData?{
    return userDefaults.dataForKey(key)
  }
  
}
  