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
let userInfoAPI = "http://192.168.2.227:3000" + "/api/v1/users/app_user_info.json?access_token="
class User{
  let id: String?
  let avator: String?
  let username: String?
  let QRimage: [String]?
  let posts: [Post]?
  let collections: [String]?
  static var user: User?
  static var currentUser: User?{
    set{
      user = newValue
    }
    get{
      if let user = self.user{
        return user
      } else if let user = getUserFromAccessToken(){
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
  
//  static func currentUser()->User?{
//    return User(id: "", username: "", avator: "alkdsf", QRimage: [""], posts: [Post()], collections: [""])
//    return nil
//  }
  
  static func getUserFromAccessToken()-> User?{
    let database = NSUserDefaults.standardUserDefaults()
    if let token = database.stringForKey(UserConfig.userToken){
      //TODO
      return nil
    }
    return nil
  }
  
  static func checkAccount(email: String, password: String) -> String?{
    return "faketoken"
  }
  
  static func getUserInfo(accessToken: String, callback: (User?)->()){
    print("running2")
    Alamofire.request(.GET, userInfoAPI + accessToken).response{ request, response, data, error in
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
      
      if error != nil{
        print(error)
        callback(nil)
      } else {
        callback(user)
      }
    }
  }
}