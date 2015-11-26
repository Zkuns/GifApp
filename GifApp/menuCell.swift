//
//  menuCell.swift
//  GifApp
//
//  Created by 朱坤 on 11/25/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
  
  func setData(menuName: String, imageName: String){
    self.textLabel!.text = menuName
    self.imageView!.image = imageWithImage(UIImage(named: imageName)!, scaledToSize: CGSize(width: 30, height: 30))
  }
  
  //就是将图片resize一下
  private func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
    image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
    let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
  }
}
