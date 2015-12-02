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
let userInfoAPI = OmniauthConfig.resoureUrl + "/api/v1/users/app_user_info.json?access_token="
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
      database.setObject(UserConfig.userTokenKey, forKey: newValue!)
    }
    get{
      return database.stringForKey(UserConfig.userTokenKey)
    }
  }
  static var currentUser: User?{
    set{
      user = newValue
    }
    get{
      if let user = self.user{
        return user
      } else if let user = getUserFromLocal(){
        return user
      } else {
        return nil
      }
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
  
  static func getUserFromLocal()-> User?{
    if let token = database.stringForKey(UserConfig.userTokenKey){
      getUserInfo(token){ user in
        currentUser = user
      }
    }
    return nil
  }
  
  static func getUserFromNetWork(email: String, password: String, callback: (User?)->()){
    Alamofire.request(.POST, userAccessTokenAPI, parameters: ["email": email, "password": password, "grant_type": "password", "client_id": OmniauthConfig.client_id, "client_secret": OmniauthConfig.client_secret]).response{ request, response, data, error in
      print("success")
      let data = JSON(data: data!)
      print(data)
      if data["error"] != nil{
        print(email)
        print(password)
        print("password error")
      } else {
        let access_token = data["access_token"].string!
        print(data["refresh_token"].string!)
        getUserInfo(access_token, callback: callback)
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