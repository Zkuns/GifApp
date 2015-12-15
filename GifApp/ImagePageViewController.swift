//
//  ImagePageViewController.swift
//  GifApp
//
//  Created by 朱坤 on 12/15/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import UIKit

class ImagePageViewController: UIViewController {
  var pageViewController: UIPageViewController?
  var images: [String]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initPageViewController()
    addDisappearGesture()
  }
  
  func initPageViewController() {
    pageViewController = storyboard?.instantiateViewControllerWithIdentifier("imagePageViewController") as? UIPageViewController
    pageViewController?.dataSource = self
    addChildViewController(pageViewController!)
    view.addSubview((pageViewController?.view)!)
    pageViewController?.didMoveToParentViewController(self)
    if images?.count > 0{
      let firstController = getImageDetailViewController(0)
      pageViewController?.setViewControllers([firstController!], direction: .Forward, animated: true, completion: nil)
    }
  }
  
  func getImageDetailViewController(index: Int) -> ImageDetailController?{
    let controller = storyboard?.instantiateViewControllerWithIdentifier("imageDetailController") as? ImageDetailController
    controller?.index = index
    controller?.imageUrl = images?[index]
    return controller
  }
  
  private func addDisappearGesture(){
    let disappear = UITapGestureRecognizer(target: self, action: "disappear:")
    self.view.addGestureRecognizer(disappear)
  }
}

extension ImagePageViewController: UIPageViewControllerDataSource {
  func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
    return images?.count ?? 0
  }
  
  func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
    return 0
  }

  func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
    let detailController = viewController as! ImageDetailController
    if var index = detailController.index{
      index--
      if index < 0 {
        if let count = images?.count{
          index = count - 1
        }
      }
      let detailController = getImageDetailViewController(index)
      return detailController
    } else {
      return getImageDetailViewController(0)
    }
  }
  
  func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
    let detailController = viewController as! ImageDetailController
    if var index = detailController.index{
      index++
      if index >= images?.count ?? 0 { index = 0 }
      let detailController = getImageDetailViewController(index)
      return detailController
    } else {
      return getImageDetailViewController(0)
    }
  }
}

extension ImagePageViewController: UIGestureRecognizerDelegate{
  func disappear(recogizer: UIPanGestureRecognizer){
    disappear()
  }
  
  private func disappear(){
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    appDelegate.window?.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
  }
}


