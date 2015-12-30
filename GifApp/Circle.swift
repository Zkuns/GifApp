//
//  Circle.swift
//  GifApp
//
//  Created by 朱坤 on 12/28/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import UIKit

class Circle: UIView {
  
  var pen :UIBezierPath?
  
  var scale: CGFloat?{
    didSet{
      setNeedsDisplay()
    }
  }
  
  var corner: CGFloat{
    get{
      if let scale = scale {
        return CGFloat(2 * M_PI) * scale - CGFloat(M_PI / 2)
      } else {
        return CGFloat(1.5 * M_PI)
      }
    }
  }
  
  var centerPoint: CGPoint{
    return convertPoint(center, fromView: superview)
  }
  
  var radius: CGFloat{
    return min(bounds.width, bounds.height) / 2
  }
  
  override func drawRect(rect: CGRect) {
    pen = UIBezierPath(arcCenter: centerPoint, radius: 20, startAngle: CGFloat(1.5 * M_PI), endAngle: corner, clockwise: true)
    pen?.lineWidth = 3
    UIColor.whiteColor().setStroke()
    pen?.stroke()
  }
}
