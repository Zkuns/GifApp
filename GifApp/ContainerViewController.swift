//
//  ViewController.swift
//  GifApp
//
//  Created by 朱坤 on 11/24/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import UIKit

enum State{
  case Open //显示menu的状态
  case Close //关闭menu的状态
}

//用于点击menu时切换controller的protocol
protocol ChangeControllerDelegate{
  func changeController(menuItem: MenuItem)
  func changeToUserCenterController(index: Int)
}

class ContainerViewController: UIViewController{
  //当前的开关状态
  var currentState = State.Close
  //打开使用的遮罩层
  var maskView: UIView?
  var panGesture: UIPanGestureRecognizer?
  var tapGesture: UITapGestureRecognizer?
  let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
  var menuViewController: MenuViewController?
  var currentMenuItem: MenuItem?{
    didSet{
      updateNavigationControllerUI()
    }
  }
  
  var containerNavigationController = UINavigationController()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    //添加menuController
    menuViewController = storyBoard.instantiateViewControllerWithIdentifier("menu") as? MenuViewController
    addChildViewController(menuViewController!)
    view.addSubview(menuViewController!.view)
    menuViewController!.delegate = self
    menuViewController!.didMoveToParentViewController(self)
    
    panGesture = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
    tapGesture = UITapGestureRecognizer(target: self, action: "handleTapGesture:")
    maskView = UIView(frame: CGRect(origin: containerNavigationController.view.frame.origin, size: CGSize(width: Config.menu_width, height: containerNavigationController.view.frame.height)))
    let maskGesture = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
    maskView?.addGestureRecognizer(tapGesture!)
    maskView?.addGestureRecognizer(maskGesture)
    
    addChildViewController(containerNavigationController)
    view.addSubview(containerNavigationController.view)
    containerNavigationController.didMoveToParentViewController(self)
    containerNavigationController.navigationBar.tintColor = UIColor.whiteColor()
    containerNavigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    containerNavigationController.navigationBar.barTintColor = ColorConfig.greenColor
    containerNavigationController.navigationBar.translucent = false;
    currentMenuItem = MenuItem.menuItems.first
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    if(appDelegate.firstLaunch){
      loadLaunchView()
      appDelegate.firstLaunch = false
    }
    
    NSNotificationCenter.defaultCenter().addObserverForName(NotificationName.userLogout, object: nil, queue: NSOperationQueue.mainQueue()){ notification in
      self.changeController(MenuItem.menuItems.first!)
    }
    
  }
  func loadLaunchView(){
    let launchView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
    let launchViewController = LaunchScreenController()
    self.addChildViewController(launchViewController)
    launchView.addSubview(launchViewController.view)
    self.view.addSubview(launchView)
  }
  
  //更新containerNavigationController的UI
  func updateNavigationControllerUI(){
    let controller = storyBoard.instantiateViewControllerWithIdentifier(currentMenuItem!.controllerName)
    containerNavigationController.viewControllers = [controller]
    controller.view.addGestureRecognizer(panGesture!)
    
    let image = UIImage(named: "menu")
    let button = UIButton(frame: CGRectMake(0, 0, (image?.size.width)!, (image?.size.height)!))
    button.setBackgroundImage(image, forState: .Normal)
    button.addTarget(self, action: "toggle:", forControlEvents: UIControlEvents.TouchUpInside)
    controller.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    controller.title = currentMenuItem!.menuName
  }
  
  func toggle(sender: UIButton){
    toggleMenu()
  }
  
  func toggleMenu(){
    var action = {}
    switch currentState{
    case .Open:
      maskView?.removeFromSuperview()
      action = {
        self.containerNavigationController.view.transform = CGAffineTransformMakeScale(1, 1)
        self.containerNavigationController.view.frame.origin.x = 0
      }
      currentState = .Close
    case .Close:
      containerNavigationController.view.addSubview(maskView!)
      action = {
        self.containerNavigationController.view.frame.origin.x = self.view.frame.width - Config.menu_width
        self.containerNavigationController.view.transform = CGAffineTransformMakeScale(Config.menu_ratio, Config.menu_ratio)
      }
      currentState = .Open
    }
    UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: action, completion: nil)
  }
  
}

extension ContainerViewController: UIGestureRecognizerDelegate{
  func handlePanGesture(recogizer: UIPanGestureRecognizer){
    if abs(recogizer.velocityInView(view).x) > 10{
      let left = recogizer.velocityInView(view).x < 0
      switch recogizer.state{
      case .Changed:
        if (currentState == .Close){
          animateController(0, origin_ratio: 1, size: recogizer.translationInView(view).x)
        } else{
          animateController(view.frame.size.width - CGFloat(Config.menu_width), origin_ratio: Config.menu_ratio, size: recogizer.translationInView(view).x)
        }
      case .Ended:
        if (currentState == .Close) && !left{
          toggleMenu()
        } else if (currentState == .Open) && left {
          toggleMenu()
        } else {
          if currentState == .Open{
            currentState = .Close
            toggleMenu()
          } else {
            currentState = .Open
            toggleMenu()
          }
          toggleMenu()
        }
      default: break
      }
    }
  }
  
  private func animateController(origin_x: CGFloat, origin_ratio: CGFloat, size: CGFloat){
    if ((origin_x + size) < 0){
      containerNavigationController.view.frame.origin.x = 0
    } else if (origin_x + size > view.frame.size.width - CGFloat(Config.menu_width)){
      containerNavigationController.view.frame.origin.x = view.frame.size.width - CGFloat(Config.menu_width)
//      self.containerNavigationController.view.transform = CGAffineTransformMakeScale(1, 1)
    } else {
      containerNavigationController.view.frame.origin.x = origin_x + size
      let ratio = (size / (view.frame.width - Config.menu_width)) * 0.2
      self.containerNavigationController.view.transform = CGAffineTransformMakeScale(origin_ratio - ratio, origin_ratio - ratio)
    }
  }
  
  func handleTapGesture(recogizer: UITapGestureRecognizer){
    toggleMenu()
  }
}

extension ContainerViewController: ChangeControllerDelegate{
  func changeController(menuItem: MenuItem) {
    if currentMenuItem!.controllerName != menuItem.controllerName{
      currentMenuItem = menuItem
    }
    toggleMenu()
  }
  func changeToUserCenterController(index: Int) {
    changeController(MenuItem(controllerName: "UserViewController", menuName: "用户中心", imageName: "cat"))
    if let controller = containerNavigationController.viewControllers.first as? UserCenterViewController{
      controller.index = index
    }
  }
}

