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
  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var publish_at: UILabel!
  @IBOutlet weak var images: GridView!
  @IBOutlet weak var body: UILabel!
  var post: Post?{
    didSet{
      updateUI()
    }
  }
  
  func updateUI(){
    title.text = post?.title ?? " "
    body.text = post?.body ?? " "
    publish_at.text = TimeUtil.fomatTime(post?.publish_at, form: "HH:mm")
    publish_at.sizeToFit()
    title.sizeToFit()
    body.sizeToFit()
    images.sizeToFit()
    images.reloadData()
  }
  
  func setData(post: Post?){
    images.images = post?.images
    images.delegate = self
    images.dataSource = self
    self.post = post
  }
  
  func getRowHeight() -> CGFloat{
    let constraint_height: CGFloat = 40
//    let real_height = body.frame.height + CGFloat(body.numberOfLines * 2)
//    print(real_height)
    return constraint_height + title.frame.height + publish_at.frame.height + body.frame.height + images.frame.height
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
    detailImageDelegate?.openDetail((post?.images?[indexPath.row])!)
  }
}

extension PostCell: UICollectionViewDelegateFlowLayout{
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
    var width = 115
    var height = 115
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
    return 5
  }
  
}
