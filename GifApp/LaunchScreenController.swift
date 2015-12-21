//
//  LaunchScreenController.swift
//  GifApp
//
//  Created by ScorpiusZ on 15/11/27.
//  Copyright © 2015年 Zkuns. All rights reserved.
//

import UIKit

class LaunchScreenController: ApplicationViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    startAnimation()
  }
  
  func startAnimation(){
    let height = UIScreen.mainScreen().bounds.height
    let width = UIScreen.mainScreen().bounds.width
    let imgView = UIImageView(frame: CGRectMake(0, 0, width , height))
    imgView.backgroundColor = UIColor.blackColor()
    imgView.contentMode = UIViewContentMode.ScaleAspectFit
    imgView.image = UIImage(named: LaunchConfig.screenImgName)
    
    let tapGesture = UITapGestureRecognizer(target: self, action: "closeLaunchScreen:")
    self.view.addGestureRecognizer(tapGesture)
    
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

extension LaunchScreenController: UIGestureRecognizerDelegate{
  func closeLaunchScreen(recognizer: UITapGestureRecognizer){
    self.view.superview?.removeFromSuperview()
  }
}
