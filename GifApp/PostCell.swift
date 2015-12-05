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
  @IBOutlet weak var deleteButton: UIButton!
  
  func setData(post: Post?, current_user_id: String?){
    Images.delegate = self
    Images.dataSource = self
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
//        deleteButton.alpha = 0
      }
    }
  }
}

extension PostCell: UICollectionViewDataSource{
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 10
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = Images.dequeueReusableCellWithReuseIdentifier("imageCell", forIndexPath: indexPath) as! ImageCell
    cell.backgroundColor = UIColor.blackColor()
    cell.imageView.image = UIImage(named: "cat")
    return cell
  }
}

extension PostCell: UICollectionViewDelegate{
  
}

extension PostCell: UICollectionViewDelegateFlowLayout{
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
    let size = CGSize(width: 100, height: 100)
    return size
  }
  func collectionView(collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAtIndex section: Int) -> UIEdgeInsets {
      return UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)
  }
}