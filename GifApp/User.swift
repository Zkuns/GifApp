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
let userInfoAPI = OmniauthConfig.resoureUrl + "/api/v1/activities/d345e8e8-f512-4192-8cb7-7aaf19f3a084/users/ticket_info.json?access_token="
let userAccessTokenAPI = OmniauthConfig.authenticateUrl + "/oauth/token"
class User{
  let id: String?
  let avator: String?
  let username: String?
  let QRimage: [String]?
  let posts: [Post]?
  let collections: [String]?
  static let database = NSUserDefaults.standardUserDefaults()
  static var user: User?
  static var access_token: String?{
    set{
      if (newValue != nil){
        database.setObject(newValue!, forKey: UserConfig.userTokenKey)
        database.synchronize()
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: NotificationName.userChanged, object: nil))
      } else {
        database.setObject(nil, forKey: UserConfig.userTokenKey)
      }
    }
    get{
      return database.stringForKey(UserConfig.userTokenKey)
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
  
  init(id: String?, username: String?, avator: String?, QRimage: [String]?, posts: [Post]?, collections: [String]?){
    self.id = id
    self.username = username
    self.avator = avator
    self.QRimage = QRimage
    self.posts = posts
    self.collections = collections
  }
  
  static func login(email: String, passwd: String){
    Alamofire.request(.POST, userAccessTokenAPI, parameters: ["email": email, "password": passwd, "grant_type": "password", "client_id": OmniauthConfig.client_id, "client_secret": OmniauthConfig.client_secret]).response{ request, response, data, error in
      let data = JSON(data: data!)
      if data["error"] != nil{
      } else if data["access_token"].string != nil {
        access_token = data["access_token"].string!
      }
    }
  }
  
  
  static func getUserInfo(accessToken: String, callback: (User?)->()){
    Alamofire.request(.GET, userInfoAPI + accessToken).response{ request, response, data, error in
      if error != nil{
        print(error)
        callback(nil)
      } else {
        print(userInfoAPI + accessToken)
        print(data)
        let data = JSON(data: data!)
        print(data)
        let QRimages = data["qrcode"].array!.map{ qrImage -> String in
          return qrImage["id"].string!
        }
        //      let posts = data["posts"].array
        //      let collection = data["comments"].array
        user = User(id: data["id"].string, username: data["username"].string, avator: data["avator"].string, QRimage: QRimages, posts: [], collections: [])
        callback(user)
      }
    }
  }
}