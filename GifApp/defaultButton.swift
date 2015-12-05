//
//  defaultButton.swift
//  GifApp
//
//  Created by 朱坤 on 12/2/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import UIKit

class defaultButton: UIButton {
  override var highlighted: Bool{
    didSet{
      if (highlighted){
        self.alpha = 0.8
      } else {
        self.alpha = 1
      }
    }
  }
}
