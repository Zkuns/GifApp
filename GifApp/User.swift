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
    let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
    configuration.timeoutIntervalForRequest = 4
    Alamofire.Manager(configuration: configuration).request(.POST, userAccessTokenAPI, parameters: ["email": email, "password": passwd, "grant_type": "password", "client_id": OmniauthConfig.client_id, "client_secret": OmniauthConfig.client_secret]).response{ request, response, data, error in
      let data = JSON(data: data!)
      if HttpUtils.isSuccess(response) {
        if data["error"] {
          callback(false, resultMsg: "账号或密码错误")
        } else if data["access_token"].string != nil {
          access_token = data["access_token"].string!
          callback(true, resultMsg: "登录成功")
        } else {
          callback(false, resultMsg: "网络错误")
        }
      }else{
        callback(false, resultMsg: "网络连接错误")
      }
    }
  }
  
  static func logout(){
    user = nil
    access_token = nil
  }
  
  
  static func getUserInfo(accessToken: String, callback: (User?)->()){
    Alamofire.request(.GET, userInfoAPI + accessToken).response{ request, response, data, error in
      let statusCode = response?.statusCode ?? -1
      if statusCode < 200 || statusCode >= 300 {
        callback(nil)
      } else {
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