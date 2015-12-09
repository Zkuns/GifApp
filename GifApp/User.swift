//
//  User.swift
//  GifApp
//
//  Created by 朱坤 on 11/28/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

//let userInfoAPI = Config.baseUrl + "/api/v1/users/app_user_info.json?access_token="
let userInfoAPI = OmniauthConfig.resoureUrl + "/api/v1/activities/\(Config.currentActivityId)/users/app_user_info.json?access_token="
let userAccessTokenAPI = OmniauthConfig.authenticateUrl + "/oauth/token"
class User{
  let id: String?
  let avator: String?
  let username: String?
  let tickets: [Ticket]?
  let posts: [Post]?
  let collections: [String]?
  static let database = NSUserDefaults.standardUserDefaults()
  static var user: User?
  static var access_token: String?{
    set{
      LocalStorage.setString(UserConfig.userTokenKey, value: newValue)
      NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: NotificationName.userChanged, object: nil))
    }
    get{
      return LocalStorage.getString(UserConfig.userTokenKey)
    }
  }
  
  static func getCurrentUser(callback: (User?)->() ){
    if access_token != nil {
      getUserInfo(access_token!){ user in
        callback(user)
        self.user = user
      }
    }else{
      callback(nil)
    }
  }
  
  init(id: String?, username: String?, avator: String?, tickets: [Ticket]?, posts: [Post]?, collections: [String]?){
    self.id = id
    self.username = username
    self.avator = avator
    self.tickets = tickets
    self.posts = posts
    self.collections = collections
  }
  
  static func login(email: String, passwd: String,callback: (Bool,resultMsg: String)->() ){
    Alamofire.request(.POST, userAccessTokenAPI, parameters: ["email": email, "password": passwd, "grant_type": "password", "client_id": OmniauthConfig.client_id, "client_secret": OmniauthConfig.client_secret]).response{ request, response, data, error in
      let data = JSON(data: data!)
      if data["error"] != nil{
        callback(false,resultMsg: "登录失败")
      } else if data["access_token"].string != nil {
        access_token = data["access_token"].string!
        callback(true,resultMsg: "登录成功")
      }
    }
  }
  
  static func logout(){
    user = nil
    access_token = nil
  }
  
  
  static func getUserInfo(accessToken: String, callback: (User?)->()){
    print(accessToken)
    Alamofire.request(.GET, userInfoAPI + accessToken).response{ request, response, data, error in
      let statusCode = response?.statusCode ?? -1
      print("getUserInfo statusCode = \(statusCode)")
      if statusCode < 200 || statusCode >= 300 {
        print(error)
        callback(nil)
      } else {
        print(userInfoAPI + accessToken)
        let data = JSON(data: data!)
//        let posts = data["posts"].array
//        let collection = data["comments"].array
        let tickets = data["ticket"].array!.map{ data -> Ticket in
          return Ticket(id: data["id"].string!, title: data["title"].string!)
        }
        user = User(id: data["id"].string, username: data["username"].string, avator: data["avator"].string, tickets: tickets, posts: [], collections: [])
        callback(user)
      }
    }
  }
}