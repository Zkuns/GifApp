//
//  ImageViewcontroller.swift
//  GifApp
//
//  Created by 朱坤 on 12/8/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import UIKit
import Kingfisher
import Toast

class ImageDetailController: UIViewController, UIScrollViewDelegate{
  
  @IBOutlet weak var scrollView: UIScrollView!
  var delegate: pageIndexDelegate?
  var index: Int?
  var imageView = UIImageView()
  var imageUrl: String?
  var top_margin: CGFloat = 0 //用来动态计算图像的高度
  var circle = Circle()
  
  override func viewDidLoad(){
    super.viewDidLoad()
    initView()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    delegate?.setPageIndexView((index ?? 1) + 1)
  }
  
  func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
    return imageView
  }
  
  func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
    UIView.animateWithDuration(0.3) { () -> Void in
      self.imageView.frame.origin.y = (scrollView.maximumZoomScale - scale) / (scrollView.maximumZoomScale - 1) * self.top_margin
    }
  }
  
  private func initView() {
    guard let imageUrl = imageUrl else { return }
    initCircle()
    imageView.kf_setImageWithURL(NSURL(string: imageUrl)!,
      placeholderImage: nil,
      optionsInfo: nil,
      progressBlock: { (receivedSize, totalSize) -> () in
        let scale = CGFloat(receivedSize)/CGFloat(totalSize)
        self.circle.scale = scale
        self.circle.setNeedsDisplay()
      },
      completionHandler: { (image, error, cachetype, imageURL) -> () in
        self.removeCircle()
        guard error == nil else {
          self.view.makeToast("网络连接失败", duration: 1, position: CSToastPositionCenter, style: nil)
          return
        }
        let width = image!.size.width
        let height = image!.size.height
        let image_height = self.view.frame.width * height / width
        var maxScale: CGFloat = 2
        var origin: CGPoint = CGPointZero
        if self.view.frame.height / image_height > 1{
          self.top_margin = (self.view.frame.height - image_height)/2
          origin = CGPoint(x: 0, y: self.top_margin)
          maxScale = self.view.frame.height / image_height
        } else {
          self.scrollView.contentSize.height = image_height
        }
        self.imageView.frame = CGRect(origin: origin, size: CGSize(width: self.view.frame.width, height: image_height ))
        self.scrollView.addSubview(self.imageView)
        self.scrollView.maximumZoomScale = maxScale
        self.scrollView.delegate = self
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.scrollsToTop = false
      })
  }
  
  private func initCircle(){
    circle.frame = CGRect(origin: CGPoint(x: view.center.x - 30, y: view.center.y - 30), size: CGSize(width: 60, height: 60))
    circle.backgroundColor = UIColor.blackColor()
    self.view.addSubview(circle)
  }
  
  private func removeCircle(){
    circle.removeFromSuperview()
  }
  
}
