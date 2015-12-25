//
//  menuCell.swift
//  GifApp
//
//  Created by 朱坤 on 11/25/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
  
  @IBOutlet weak var menuImage: UIImageView!
  @IBOutlet weak var menuText: UILabel!
  
  func setData(menuName: String, imageName: String){
    self.contentView.backgroundColor = ColorConfig.yellowColor
    menuText.text! = menuName
    menuImage.image = UIImage(named: imageName)
  }
}
