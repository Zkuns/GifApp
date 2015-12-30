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
  
  private static var refresh_token: String?{
    set{
      LocalStorage.setString(UserConfig.userRefreshKey, value: newValue)
    }
    get{
      return LocalStorage.getString(UserConfig.userRefreshKey)
    }
  }
  
  static var user: User?{
    didSet{
      NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: NotificationName.userSeted, object: nil))
    }
  }
  
  static var access_token: String?{
    set{
      LocalStorage.setString(UserConfig.userTokenKey, value: newValue)
      NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: NotificationName.userChanged, object: nil))
    }
    get{
      return LocalStorage.getString(UserConfig.userTokenKey)
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
  
  static func login(let email: String, let passwd: String,callback: (Bool,resultMsg: String)->() ){
    Alamofire.request(.POST, userAccessTokenAPI, parameters: ["email": email.lowercaseString, "password": passwd, "grant_type": "password", "client_id": OmniauthConfig.client_id, "client_secret": OmniauthConfig.client_secret]).response{ request, response, data, error in
      let data = JSON(data: data!)
      if HttpUtils.isSuccess(response) {
        refresh_token = data["refresh_token"].string!
        access_token = data["access_token"].string!
        callback(true, resultMsg: "登录成功")
      }else{
        if data["error"] != nil {
          callback(false, resultMsg: "账号或密码错误")
        } else {
          callback(false, resultMsg: "网络错误")
        }
      }
    }
  }
  
  static func logout(){
    user = nil
    access_token = nil
    refresh_token = nil
  }
  
  static func CurrentUser(callback: (User?)->() ){
    if user != nil{
      callback(user)
    } else if access_token != nil {
      getUserInfo(access_token!){ user in
        self.user = user
        callback(user)
      }
    }else{
      callback(nil)
    }
  }
  
  static func getUserInfo(accessToken: String, firstTime: Bool = true,callback: (User?)->()){
    Alamofire.request(.GET, userInfoAPI + accessToken).response{ request, response, data, error in
      if HttpUtils.isSuccess(response) {
        let data = JSON(data: data!)
        let tickets = data["ticket"].array!.map{ data -> Ticket in
          return Ticket(id: data["id"].string!, title: data["title"].string!)
        }
        user = User(id: data["id"].string, username: data["username"].string, avator: data["avator"].string, tickets: tickets, posts: [], collections: [])
        callback(user)
      } else {
        if HttpUtils.isAccesstokenError(response) && firstTime{
          refreshToken()
          getUserInfo(self.access_token ?? "", firstTime: false, callback: callback)
        } else {
          callback(nil)
        }
      }
    }
  }
  
  static func refreshToken(){
    Alamofire.request(.POST, userAccessTokenAPI, parameters: ["refresh_token": User.refresh_token ?? "", "grant_type": "refresh_token", "client_id": OmniauthConfig.client_id, "client_secret": OmniauthConfig.client_secret]).response{ request, response, data, error in
      let data = JSON(data: data!)
      if HttpUtils.isSuccess(response) {
        self.refresh_token = data["refresh_token"].string!
        self.access_token = data["access_token"].string!
      }else{
        self.access_token = nil
        self.refresh_token = nil
      }
    }
  }
}