//
//  PostDetailCell.swift
//  GifApp
//
//  Created by 朱坤 on 12/24/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import UIKit

class PostDetailCell: UITableViewCell {
  @IBOutlet weak var avator: UIImageView!
  @IBOutlet weak var body: UILabel!
  @IBOutlet weak var publish_at: UILabel!
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var images: GridView!
  var post: Post? {
    didSet{
      updateUI()
    }
  }
  var detailImageDelegate: DetailImageDelegate?
  
  func setData(post: Post?){
    images.images = post?.images
    images.delegate = self
    images.dataSource = self
    self.post = post
  }
  
  func updateUI(){
    ImageUtil.convertImageToCircle(avator)
    avator.kf_setImageWithURL(NSURL(string: post?.avator ?? "")!, placeholderImage: UIImage(named: "default_avator"))
    name.text = post?.username
    body.text = post?.body
    publish_at.text = TimeUtil.timeAgo(post?.publish_at)
    images.reloadData()
    images.sizeToFit()
  }
  
  func getHeight() -> CGFloat{
    let constraint_height: CGFloat = 60
    let body_height = post?.body?.boundingRectWithSize(CGSize(width:UIScreen.mainScreen().bounds.width-20, height: CGFloat(DBL_MAX)), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: body.font!, NSForegroundColorAttributeName: UIColor.redColor()], context: nil).height
    return constraint_height + name.frame.height + publish_at.frame.height + body_height! + images.frame.height
  }
}

extension PostDetailCell: UICollectionViewDataSource{
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

extension PostDetailCell: UICollectionViewDelegate{
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    log.info("running")
    detailImageDelegate?.openDetail(post?.images, index: indexPath.row)
  }
}

extension PostDetailCell: UICollectionViewDelegateFlowLayout{
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
