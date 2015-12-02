//
//  toggleDayButton.swift
//  GifApp
//
//  Created by 朱坤 on 12/1/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import UIKit

class ToggleDayButton: UIButton {
  let borderWidth: CGFloat = 1
  let border = UIView()
  static var buttons: [ToggleDayButton]?
  
  static func setToDefault(){
    for button in buttons!{
      button.border.removeFromSuperview()
      button.setTitleColor(ColorConfig.grayColor, forState: .Normal)
    }
  }
  
  override func drawRect(rect: CGRect) {
    super.drawRect(rect)
    self.setTitleColor(ColorConfig.greenColor, forState: .Highlighted)
  }
  
  override var highlighted: Bool{
    didSet{
      if (highlighted){
        ToggleDayButton.setToDefault()
        self.setTitleColor(ColorConfig.greenColor, forState: .Normal)
        border.backgroundColor = ColorConfig.greenColor
        border.frame = CGRectMake(0, self.frame.size.height - borderWidth, self.frame.size.width, borderWidth)
        self.addSubview(border)
      }
    }
  }
}
