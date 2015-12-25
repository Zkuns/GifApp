//
//  Comment.swift
//  GifApp
//
//  Created by 朱坤 on 11/28/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

//let commentsAPI = Config.baseUrl + "/api/v1/posts/"
let commentsAPI = "http://localhost:3000" + "/api/v1/posts/"
class Comment {
  var body: String?
  var id: String?
  var name: String?
  var avator: String?
  var publish_at: String?
  var user_id: String?
  var post_id: String?
  init(name: String?, avator: String?, publish_at: String?, body: String?, id: String?, user_id: String?, post_id: String?){
    self.name = name
    self.avator = avator
    self.publish_at = publish_at
    self.body = body
    self.id = id
    self.user_id = user_id
    self.post_id = post_id
  }
  
  static func getComments(post_id: String, callback: (Bool,[Comment]?)->()){
    Alamofire.request(.GET, postCommentAPI(post_id)).response{ request, response, data, error in
      if HttpUtils.isSuccess(response){
        let comments = JSON(data: data!)["comments"].array
        let result = comments!.map{ comment -> Comment in
          return getComment(comment)
        }
        callback(true, result)
      } else {
        callback(false, nil)
      }
    }
  }
  
  static func getComment(comment: JSON) -> Comment{
    let com = Comment(name: comment["name"].string, avator: comment["avator"].string, publish_at: comment["publish_at"].string, body: comment["body"].string, id: comment["id"].string, user_id: comment["user_id"].string, post_id: comment["post_id"].string)
    return com
  }
  
  static func postCommentAPI(post_id: String) -> String{
    return commentsAPI + post_id + "/comments/comments.json"
  }
}