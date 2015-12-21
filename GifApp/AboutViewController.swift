//
//  AboutViewController.swift
//  GifApp
//
//  Created by 朱坤 on 11/26/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import UIKit

class AboutViewController: BasicViewController{
  
  @IBOutlet weak var headImage: UIImageView!
  @IBOutlet weak var mainView: UIView!
  @IBOutlet weak var scrollView: UIScrollView!
  
  var gesture: UIPanGestureRecognizer?
  var blurEffectView: UIVisualEffectView?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addblurEffect()
    addGesture()
  }
  
  override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
    let y = scrollView.contentOffset.y
    if y<0{
      blurEffectView?.layer.opacity = 0
    } else if y > headImage.frame.height/2{
      blurEffectView?.layer.opacity = 1
    } else {
      let ratio = (y / headImage.frame.height) * 2
      blurEffectView?.layer.opacity = Float(ratio)
    }
  }
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    scrollView.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.New, context: nil)
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    scrollView.removeObserver(self, forKeyPath: "contentOffset")
  }
  
  private func addGesture(){
    gesture = UIPanGestureRecognizer(target: scrollView, action: "handleGesture:")
    self.view.addGestureRecognizer(gesture!)
  }
  
  private func addblurEffect(){
    let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
    blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView!.frame = headImage.frame
    blurEffectView!.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
    headImage.addSubview(blurEffectView!)
    blurEffectView?.layer.opacity = 0
  }
}
