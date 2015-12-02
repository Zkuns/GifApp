//
//  loginInputView.swift
//  GifApp
//
//  Created by 朱坤 on 12/2/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import UIKit

class loginInputView: UITextField{
  let buttom_border = UIView()
  override func becomeFirstResponder() -> Bool {
    let result = super.becomeFirstResponder()
    if result {
      self.tintColor = ColorConfig.yellowColor
      if let view = self.superview{
        self.textColor = ColorConfig.yellowColor
        buttom_border.frame = CGRectMake(0, view.frame.size.height - 1, view.frame.size.width, 1)
        buttom_border.backgroundColor = ColorConfig.yellowColor
        view.addSubview(buttom_border)
      }
    }
    return result
  }
  
  override func resignFirstResponder() -> Bool {
    let result = super.resignFirstResponder()
    if result {
      self.textColor = UIColor.whiteColor()
      buttom_border.removeFromSuperview()
    }
    return result
  }
}
