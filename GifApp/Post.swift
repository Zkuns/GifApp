//
//  Post.swift
//  GifApp
//
//  Created by 朱坤 on 11/28/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import Toast

let postAPI = Config.baseUrl + "/api/v1/posts?page="
//let postAPI = "http://localhost:3000/api/v1/posts?page="
let likeAPI = Config.baseUrl + "/api/v1/posts/"
//let likeAPI = "http://localhost:3000/api/v1/posts/"
class Post{
  let id: String?
  let title: String?
  let username: String?
  let body: String?
  let avator: String?
  var like_count: Int?
  let user_id: String?
  let publish_at: String
  let images: [String]?
  let comments_count: Int?
  var row_height: CGFloat?
  
  init(id: String?, title: String?, username: String?, body: String?, avator: String?, like_count: Int?, user_id: String?, publish_at: String, images: [String]?, comments: Int?){
    self.id = id
    self.title = title
    self.username = username
    self.body = body
    self.avator = avator
    self.like_count = like_count
    self.user_id = user_id
    self.publish_at = publish_at
    self.images = images
    self.comments_count = comments
  }
  
  static func getPost(post: JSON) -> Post{
    let images = post["images"].array!.map{ image-> String in
      return image.string!
    }
    let like = post["like_count"].int
    let comments_count = post["comments_count"].int
    let po = Post(id: post["id"].string, title: post["title"].string, username: post["username"].string, body: post["body"].string, avator: post["avator"].string, like_count: like, user_id: post["user_id"].string, publish_at: post["publish_at"].string!, images: images, comments: comments_count)
    return po
  }
  
  static func getData(page: Int, callback: (Bool, [Post]?)->()){
    Alamofire.request(.GET, postAPI+"\(page)").response{ request, response, data, error in
      if HttpUtils.isSuccess(response){
        let posts = JSON(data: data!)["posts"].array
        let refresh = JSON(data: data!)["refresh"].bool
        let result = posts!.map{ post -> Post in
          return getPost(post)
        }
        callback(refresh ?? true, result)
      } else {
        callback(false, nil)
      }
    }
  }
  
  static func islike(id: String) -> Bool{
    return LocalStorage.arrayContains(PostConfig.postLikeKey, value: id)
  }
  
  static func like(like: Bool, id: String){
    sendLikeRequest(like, id: id)
    if like {
      LocalStorage.removeFromArray(PostConfig.postLikeKey, value: id)
    } else {
      LocalStorage.arrayAppend(PostConfig.postLikeKey, value: id)
    }
  }
  
  private static func sendLikeRequest(like: Bool, id: String){
    Alamofire.request(.PATCH, postLikeAPI(id), parameters: ["type": !like])
  }
  
  private static func postLikeAPI(id: String) -> String{
    return likeAPI + id + "/like.json"
  }
}