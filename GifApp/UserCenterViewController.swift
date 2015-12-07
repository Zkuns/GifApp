//
//  UserCenterViewController.swift
//  GifApp
//
//  Created by ScorpiusZ on 15/12/3.
//  Copyright © 2015年 Zkuns. All rights reserved.
//

import UIKit

class UserCenterViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
  var index: Int?
  
  @IBOutlet weak var segmentControl: GSegmentControl!
  var items = [SlidePageItem]()
  var controllers: [PageViewController] = []
  private var pageViewController: PageViewController?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let rightButton = UIBarButtonItem(title: "登出", style: UIBarButtonItemStyle.Done, target: self , action: "logout")
    navigationItem.rightBarButtonItem = rightButton
    
    items=UserCenterItems.items
    initSegmentControl()
    createControllers()
    setPageViewControllerPage(0)
    
  }
  
  
  func logout(){
    User.logout()
    NSNotificationCenter.defaultCenter().postNotificationName(NotificationName.userLogout, object: nil)
  }
  private func initSegmentControl(){
    segmentControl.items = items.map{ item -> String in
      return item.title
    }
  }
  
  private func createControllers(){
    let controllerIds = items.map{ item -> String in
      return item.controllerIdentifier
    }
    for controllerIdentifier in controllerIds{
      if let controller = storyboard?.instantiateViewControllerWithIdentifier(controllerIdentifier) as? PageViewController{
        controllers.append(controller)
      }
    }
  }
  
  func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
    let itemController = viewController as! PageViewController
    return viewControllerAtIndex((itemController.itemIndex ?? 0)+1)
  }
  
  func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
    let itemController = viewController as! PageViewController
    return viewControllerAtIndex((itemController.itemIndex ?? 1)-1)
  }
  
  
  private func viewControllerAtIndex(index: Int) -> PageViewController?{
    if index > controllers.count - 1 || index < 0 {
      return nil
    }
    segmentControl.selectedIndex = index
    controllers[index].itemIndex = index
    return controllers[index]
  }
  
  private func setPageViewControllerPage(index: Int!){
    if let pageViewController = storyboard?.instantiateViewControllerWithIdentifier("PageController") as? UIPageViewController {
      pageViewController.dataSource = self
      pageViewController.delegate = self
      
      if let pageContentController = viewControllerAtIndex(index){
        pageViewController.setViewControllers([pageContentController], direction: .Forward, animated: true, completion: nil)
      }
      
      let y = segmentControl.frame.origin.y + segmentControl.frame.height
      pageViewController.view.frame = CGRectMake(0, y+10, self.view.frame.width, self.view.frame.size.height)
      
      addChildViewController(pageViewController)
      view.addSubview(pageViewController.view)
      pageViewController.didMoveToParentViewController(self)
    }
  }
  
  
  func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
    return controllers.count
  }
  
  func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
    return 0
  }
  
  @IBAction func selectPageView(sender: AnyObject) {
    setPageViewControllerPage(segmentControl.selectedIndex)
  }
}

