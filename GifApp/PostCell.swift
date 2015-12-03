//
//  postCell.swift
//  GifApp
//
//  Created by 朱坤 on 12/3/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
  
  @IBOutlet weak var like: UIButton!
  @IBOutlet weak var comment: UIButton!
  @IBOutlet weak var Images: UICollectionView!
  @IBOutlet weak var body: UILabel!
  @IBOutlet weak var publishTime: UILabel!
  @IBOutlet weak var username: UILabel!
  @IBOutlet weak var avator: UIImageView!
  @IBOutlet weak var deleteButton: UIImageView!
  
  func setData(post: Post?, current_user_id: String?){
    if let post = post{
      if let like = post.like_count{
        self.like.titleLabel?.text = (like==0 ? "点赞" : "\(like)")
      }
      if let comments_count = post.comments_count{
        self.comment.titleLabel?.text = (comments_count==0 ? "评论" : "\(comments_count)")
      }
      body.text = post.body
      publishTime.text = post.publish_at
      username.text = post.username
      avator.kf_setImageWithURL(NSURL(string: post.avator ?? "")!, placeholderImage: UIImage(named: "default_avator"))
      if(current_user_id != post.user_id){
        deleteButton.removeFromSuperview()
      }
    }
  }
}
