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
}


class ContainerViewController: UIViewController{
  //当前的开关状态
  var currentState = State.Close
  //打开使用的遮罩层
  var maskView: UIView?
  var panGesture: UIPanGestureRecognizer?
  var tapGesture: UITapGestureRecognizer?
  let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
  var currentMenuItem: MenuItem?{
    didSet{
      updateNavigationControllerUI()
    }
  }
  
  var containerNavigationController = UINavigationController()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    //添加menuController
    let menuController = storyBoard.instantiateViewControllerWithIdentifier("menu") as! MenuViewController
    addChildViewController(menuController)
    view.addSubview(menuController.view)
    menuController.delegate = self
    menuController.didMoveToParentViewController(self)
    
    containerNavigationController.view.layer.shadowOpacity = 0.8
    
    panGesture = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
    tapGesture = UITapGestureRecognizer(target: self, action: "handleTapGesture:")
    maskView = UIView(frame: CGRect(origin: containerNavigationController.view.frame.origin, size: CGSize(width: Config.menu_width, height: containerNavigationController.view.frame.height)))
    let maskGesture = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
    maskView?.addGestureRecognizer(tapGesture!)
    maskView?.addGestureRecognizer(maskGesture)
    
    currentMenuItem = MenuItem.menuItems.first
  }
  
  //更新containerNavigationController的UI
  func updateNavigationControllerUI(){
    let controller = storyBoard.instantiateViewControllerWithIdentifier(currentMenuItem!.controllerName)
    addChildViewController(containerNavigationController)
    view.addSubview(containerNavigationController.view)
    containerNavigationController.didMoveToParentViewController(self)
    containerNavigationController.pushViewController(controller, animated: false)
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
      action = { self.containerNavigationController.view.frame.origin.x = 0 }
      currentState = .Close
    case .Close:
      containerNavigationController.view.addSubview(maskView!)
      action = { self.containerNavigationController.view.frame.origin.x = self.view.frame.width - Config.menu_width }
      currentState = .Open
    }
    UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: action, completion: nil)
  }
  
}

extension ContainerViewController: UIGestureRecognizerDelegate{
  func handlePanGesture(recogizer: UIPanGestureRecognizer){
    let left = recogizer.velocityInView(view).x < 0
    switch recogizer.state{
    case .Changed:
      if (currentState == .Close){
        animateController(0, size: recogizer.translationInView(view).x)
      } else{
        animateController(view.frame.size.width - CGFloat(Config.menu_width), size: recogizer.translationInView(view).x)
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
      }
    default: break
    }
  }
  
  private func animateController(origin_x: CGFloat, size: CGFloat){
    if ((origin_x + size) < 0){
      containerNavigationController.view.frame.origin.x = 0
    } else if (origin_x + size > view.frame.size.width){
      containerNavigationController.view.frame.origin.x = view.frame.size.width
    } else {
      containerNavigationController.view.frame.origin.x = origin_x + size
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
}

