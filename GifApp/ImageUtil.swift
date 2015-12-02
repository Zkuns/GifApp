//
//  ImageUtil.swift
//  GifApp
//
//  Created by 朱坤 on 12/2/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import UIKit

class ImageUtil{
  static func convertImageToCircle(image: UIImageView){
    image.layer.masksToBounds = false
    image.layer.borderColor = UIColor.blackColor().CGColor
    image.layer.cornerRadius = image.frame.width/2
    image.clipsToBounds = true
    image.contentMode = UIViewContentMode.ScaleAspectFill
  }
}