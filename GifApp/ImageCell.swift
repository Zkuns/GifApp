//
//  imageCell.swift
//  GifApp
//
//  Created by 朱坤 on 12/4/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {

  @IBOutlet weak var imageView: UIImageView!
  
  func setImage(imageUrl: String){
    let imageUrl = imageUrl + "?imageMogr2/thumbnail/300x/crop/x300"
    imageView.kf_setImageWithURL(NSURL(string: imageUrl)!)
  }
}
