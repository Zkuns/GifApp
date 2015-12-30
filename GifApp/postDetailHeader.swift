//
//  postDetailHeader.swift
//  GifApp
//
//  Created by 朱坤 on 12/24/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import UIKit

class postDetailHeader: UITableViewCell {
  @IBOutlet weak var commentCount: UILabel!
  
  func setData(count: Int){
    commentCount.text! = "\(count)"
  }
}
