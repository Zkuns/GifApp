//
//  postCell.swift
//  GifApp
//
//  Created by 朱坤 on 12/3/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
  
  var detailImageDelegate: DetailImageDelegate?
  var openPostDetailDelegate: OpenPostDetailControllerDelegate?
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var publish_at: UILabel!
  @IBOutlet weak var images: GridView!
  @IBOutlet weak var body: UILabel!
  @IBOutlet weak var avator: UIImageView!
  @IBOutlet weak var commentCount: UILabel!
  @IBOutlet weak var likeCount: UILabel!
  @IBOutlet weak var commentImage: UIImageView!
  @IBOutlet weak var likeImage: UIImageView!
  @IBOutlet weak var buttonArea: UIView!
  
  var like = false
  
  var post: Post?{
    didSet{
      updateUI()
    }
  }
  
  func updateUI(){
    ImageUtil.convertImageToCircle(avator)
    avator.kf_setImageWithURL(NSURL(string: post?.avator ?? "")!, placeholderImage: UIImage(named: Default.avatar))
    like = Post.islike(post?.id ?? "")
    updateLikeArea(0)
    likeCount.text = "\(post?.like_count ?? 0)"
    commentCount.text = "\(post?.comments_count ?? 0)"
    name.text = post?.username ?? " "
    body.text = post?.body ?? " "
    publish_at.text = TimeUtil.fomatTime(post?.publish_at, form: "HH:mm")
    images.sizeToFit()
    images.reloadData()
  }
  
  private func updateLikeArea(change: Int){
    if like{
      likeCount.textColor = ColorConfig.yellowColor
      likeImage.image = UIImage(named: "like_touch")
    } else {
      likeCount.textColor = ColorConfig.grayColor
      likeImage.image = UIImage(named: "like")
    }
    post?.like_count! += change
    likeCount.text = "\((Int(likeCount.text!) ?? 0) + change)"
  }
  
  func setData(post: Post?){
    images.images = post?.images
    images.delegate = self
    images.dataSource = self
    self.post = post
  }
  
  @IBAction func clickComment(sender: AnyObject) {
    openPostDetailDelegate?.openDetail(post!)
  }
  
  @IBAction func clickLike(sender: AnyObject) {
    guard let id = post?.id else { return }
    Post.like(like, id: id)
    self.like = !like
    let change = like ? 1 : -1
    self.updateLikeArea(change)
  }
  
  func getRowHeight() -> CGFloat{
    let constraint_height: CGFloat = 40
    let body_height = post?.body?.boundingRectWithSize(CGSize(width:UIScreen.mainScreen().bounds.width-20, height: CGFloat(DBL_MAX)), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: body.font!, NSForegroundColorAttributeName: UIColor.redColor()], context: nil).height
    return constraint_height + name.frame.height + publish_at.frame.height + body_height! + images.frame.height + buttonArea.frame.height
  }
  
}

extension PostCell: UICollectionViewDataSource{
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return post?.images?.count ?? 0
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("imageCell", forIndexPath: indexPath) as! ImageCell
    cell.setImage((post?.images?[indexPath.row])!)
    return cell
  }
}

extension PostCell: UICollectionViewDelegate{
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    detailImageDelegate?.openDetail(post?.images, index: indexPath.row)
  }
}

extension PostCell: UICollectionViewDelegateFlowLayout{
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
    var width = UIScreen.mainScreen().bounds.width  / 3.2
    var height = width
    if (post?.images?.count ?? 0) == 1 {
      width = 300
      height = 300
      collectionView.frame = CGRect(origin: collectionView.frame.origin, size: CGSize(width: collectionView.frame.width, height: collectionView.frame.height))
    }
    return CGSize(width: width, height: height)
  }
  
  func collectionView(collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAtIndex section: Int) -> UIEdgeInsets {
      if (post?.images?.count ?? 0) == 1{
        let right = collectionView.frame.width - 300
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: right)
      }
      return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
    return 3
  }
  
}
