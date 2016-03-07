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

let commentsAPI = Config.baseUrl + "/api/v1/posts/"
//let commentsAPI = "http://localhost:3000" + "/api/v1/posts/"
class Comment: CustomStringConvertible{
  var body: String?
  var id: String?
  var name: String?
  var avator: String?
  var publish_at: String?
  var user_id: String?
  var post_id: String?
  
  var description: String {
    get {
      return "id: \(id), name: \(name), body: \(body)";
    }
  }
  
  var reported: Bool{
    get{
      return LocalStorage.arrayContains(PostConfig.reportCommentKey, value: id ?? "")
    }
    set{
      if newValue{
        LocalStorage.arrayAppend(PostConfig.reportCommentKey, value: id ?? "")
      }else{
        LocalStorage.removeFromArray(PostConfig.reportCommentKey, value: id ?? "")
      }
    }
    
  }
  init(name: String?, avator: String?, publish_at: String?, body: String?, id: String?, user_id: String?, post_id: String?){
    self.name = name
    self.avator = avator
    self.publish_at = publish_at
    self.body = body
    self.id = id
    self.user_id = user_id
    self.post_id = post_id
  }
  
  static func checkText(text: String) -> String?{
    let fomate = text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    if fomate.characters.count <= 0{
      return "评论不能为空"
    } else if fomate.characters.count >= 140{
      return "评论不能大于140个字"
    }
    return nil
  }
  
  static func getComments(post_id: String, callback: (Bool,[Comment]?)->()){
    Alamofire.request(.GET,getCommentAPI(post_id)).response{ request, response, data, error in
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
    let com = Comment(name: comment["name"].string, avator: comment["avator"].string, publish_at: comment["publish_at"].string, body: comment["body"].string, id: "\(comment["id"].int)", user_id: comment["user_id"].string, post_id: comment["post_id"].string)
    return com
  }
  
  static func getCommentAPI(post_id: String) -> String{
    return commentsAPI + post_id + "/comments/comments.json"
  }
  
  static func postCommentAPI(post_id: String) -> String{
    return commentsAPI + post_id + "/post_comments/post_comments.json"
  }
  
  static func reportCommentAPI(comment_id: String) -> String{
    return commentsAPI + comment_id + "/report_comment.json"
  }
  
  static func postComment(text: String, post_id: String, firstTime: Bool = true, callback: (Bool)->()){
    let fomat_text = text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    Alamofire.request(.POST, postCommentAPI(post_id), parameters: ["post_body": fomat_text, "access_token": User.access_token ?? ""]).response{ request, response, data, error in
      if HttpUtils.isSuccess(response){
        callback(true)
      } else {
        if HttpUtils.isAccesstokenError(response) && firstTime{
          User.refreshToken()
          postComment(text, post_id: post_id, firstTime: false, callback: callback)
        } else {
          callback(false)
        }
      }
    }
  }
  
  func uploadReportComment(callback: ()->()){
    reported = !reported
    Alamofire.request(.POST, Comment.reportCommentAPI(self.id ?? "")).response{
      request, response, data, error in
      callback()
    }
  }
  
}