//
//  ImageViewcontroller.swift
//  GifApp
//
//  Created by 朱坤 on 12/8/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import UIKit

class ImageDetailController: UIViewController, UIScrollViewDelegate{
  
  @IBOutlet weak var scrollView: UIScrollView!
  var delegate: pageIndexDelegate?
  
  var index: Int?
  var imageView = UIImageView()
  var imageUrl: String?
  
  override func viewDidLoad(){
    super.viewDidLoad()
    initView()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    delegate?.setPageIndexView((index ?? 1) + 1)
  }
  
  func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView?{
    return imageView
  }
  
  func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
//    scrollView.contentInset = UIEdgeInsetsMake(0, 0, 300, 0);
  }
  
  private func initView(){
    if let imageUrl = imageUrl{
      dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)){
        let data = NSData(contentsOfURL: NSURL(string: imageUrl)!)
        dispatch_async(dispatch_get_main_queue()){
          let image = UIImage(data: data!)
          let width = image!.size.width
          let height = image!.size.height
          
          let image_height = self.view.frame.width * height / width
          let origin: CGPoint = CGPoint(x: 0, y: (self.view.frame.height - image_height)/2)
          self.imageView.image = image
          self.imageView.frame = CGRect(origin: origin, size: CGSize(width: self.view.frame.width, height: image_height ))
          self.scrollView.addSubview(self.imageView)
          self.scrollView.contentSize = self.imageView.frame.size
          let maxScale: CGFloat = (self.view.frame.height % image_height) > 1 ? (self.view.frame.height / image_height) : 1
          self.scrollView.maximumZoomScale = maxScale
          self.scrollView.delegate = self
          self.scrollView.minimumZoomScale = 1.0
        }
      }
    }
  }
  
}
