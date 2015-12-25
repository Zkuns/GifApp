//
//  ImagePageViewController.swift
//  GifApp
//
//  Created by 朱坤 on 12/15/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import UIKit

protocol pageIndexDelegate{
  func setPageIndexView(page: Int)
}
class ImagePageViewController: UIViewController {
  @IBOutlet weak var pageIndex: UILabel!
  
  var pageViewController: UIPageViewController?
  var images: [String]?
  var currentPage: Int?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setPageIndexView(currentPage ?? 0)
    initPageViewController()
    addDisappearGesture()
  }
  
  func initPageViewController() {
    pageViewController = storyboard?.instantiateViewControllerWithIdentifier("imagePageViewController") as? UIPageViewController
    pageViewController?.dataSource = self
    let height = pageIndex.frame.height + 20
    pageViewController?.view.frame = CGRect(x: 0, y: height, width: view.frame.width, height: view.frame.height-height)
    addChildViewController(pageViewController!)
    view.addSubview((pageViewController?.view)!)
    pageViewController?.didMoveToParentViewController(self)
    if images?.count > 0 {
      let firstController = getImageDetailViewController(currentPage ?? 0)
      pageViewController?.setViewControllers([firstController!], direction: .Forward, animated: true, completion: nil)
    }
  }
  
  func getImageDetailViewController(index: Int) -> ImageDetailController? {
    let controller = storyboard?.instantiateViewControllerWithIdentifier("imageDetailController") as? ImageDetailController
    controller?.index = index
    controller?.delegate = self
    controller?.imageUrl = images?[index]
    return controller
  }
  
  private func addDisappearGesture() {
    let disappear = UITapGestureRecognizer(target: self, action: "disappear:")
    self.view.addGestureRecognizer(disappear)
  }
}

extension ImagePageViewController: UIPageViewControllerDataSource {
  func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
    let detailController = viewController as! ImageDetailController
    if var index = detailController.index{
      index++
      if index >= images?.count ?? 0 {
        if images?.count == 1 {
          return nil
        } else {
          index = 0
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
      index--
      if index < 0 {
        if images?.count == 1{
          return nil
        } else {
          index = (images?.count ?? 0) - 1
        }
      }
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

extension ImagePageViewController: pageIndexDelegate{
  func setPageIndexView(page: Int){
    pageIndex.text! = "\(page)/\(images?.count ?? 0)"
  }
}

