//
//  LaunchScreenController.swift
//  GifApp
//
//  Created by ScorpiusZ on 15/11/27.
//  Copyright © 2015年 Zkuns. All rights reserved.
//

import UIKit

class LaunchScreenController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    print("LaunchView viewDidLoad")
    startAnimation()
  }
  
  func startAnimation(){
    let height = UIScreen.mainScreen().bounds.height
    let width = UIScreen.mainScreen().bounds.width
    print("height = \(height), width = \(width)")
    let imgView = UIImageView(frame: CGRectMake(0, 0, width , height))
    imgView.backgroundColor = UIColor.blackColor()
    imgView.contentMode = UIViewContentMode.ScaleAspectFit
    imgView.image = UIImage(named: LaunchConfig.screenImgName)
    
    view?.addSubview(imgView)
    
    UIView.animateWithDuration(3,animations:{
      let height = UIScreen.mainScreen().bounds.size.height
      let rect = CGRectMake(-100,-100,width+200,height+200)
      imgView.frame = rect
      },completion:{
        (Bool completion) in
        if completion {
          UIView.animateWithDuration(1,animations:{
            imgView.alpha = 0
            },completion:{
              (Bool completion) in
              if completion {
                self.view.superview?.removeFromSuperview()
              }
          })
        }
    })
  }

}
