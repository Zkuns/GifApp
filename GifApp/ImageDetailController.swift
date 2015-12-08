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
  @IBOutlet weak var pageControl: UIPageControl!
  
  var imageView = UIImageView()
  var image: UIImage?
  
//  var currentPageView: UIImageView?
//  
//  var pageImages: [UIImage]?{
//    didSet{
////      updateUI()
//    }
//  }
  
  override func viewDidLoad(){
    super.viewDidLoad()
    let disappear = UITapGestureRecognizer(target: self, action: "disappear:")
    scrollView.addGestureRecognizer(disappear)
    initView()
  }
  
  func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView?{
    return imageView
  }
  
  func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
    scrollView.contentInset = UIEdgeInsetsMake(0, 0, 300, 0);
  }
  
//  func scrollViewDidScroll(scrollView: UIScrollView) {
//    loadVisiblePages()
//  }
//  
//  private func updateUI(){
//    if let images = pageImages{
//      pageControl.currentPage = 0
//      pageControl.numberOfPages = images.count
//      let pagesScrollViewSize = scrollView.frame.size
//      scrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(images.count),
//        height: pagesScrollViewSize.height)
//      loadVisiblePages()
//    }
//  }
//  
//  private func loadPage(page: Int){
//    if page < 0 || page > pageImages!.count{
//      return
//    }
//    if pageControl.currentPage != page{
//    print("current page is \(page) page count is \(pageImages?.count)")
//      var frame = scrollView.bounds
//      frame.origin.x = frame.size.width * CGFloat(page)
//      frame.origin.y = 0.0
//      
//      let newPageView = UIImageView(image: pageImages![page])
//      newPageView.contentMode = .ScaleAspectFit
//      newPageView.frame = frame
//      scrollView.addSubview(newPageView)
//      currentPageView?.removeFromSuperview()
//      currentPageView = newPageView
//    }
//  }
//  
//  func loadVisiblePages(){
//    let pageWidth = scrollView.frame.size.width
//    let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
//    loadPage(page)
//  }
  
  private func initView(){
    if let image = image{
      imageView.image = image
      let width = image.size.width
      let height = image.size.height
      
      let image_height = view.frame.width * height / width
      let origin: CGPoint = CGPoint(x: 0, y: (view.frame.height - image_height)/2)
      
      imageView.frame = CGRect(origin: origin, size: CGSize(width: view.frame.width, height: image_height ))
      scrollView.addSubview(imageView)
      scrollView.contentSize = imageView.frame.size
      scrollView.delegate = self
      scrollView.minimumZoomScale = 1.0
      let maxScale: CGFloat = (view.frame.height % image_height) > 1 ? (view.frame.height / image_height) : 1
      scrollView.maximumZoomScale = maxScale
    }
  }
  
}

extension ImageDetailController: UIGestureRecognizerDelegate{
  func disappear(recogizer: UIPanGestureRecognizer){
    disappear()
  }
  
  private func disappear(){
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    appDelegate.window?.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
  }
}


