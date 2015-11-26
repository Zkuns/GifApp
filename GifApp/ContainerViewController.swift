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

//用于menu切换动画的两个protocol, 前者containerViewController实现，后者为带切换按钮的controller实现
protocol ToggleControllerDelegate{
  func toggleMenu()
}
protocol CommonController{
  var toggleDelegate: ToggleControllerDelegate?{ get set }
  func toggleMenu(sender: UIButton)
  func addNavigationBar()
}

//用于点击menu时切换controller的protocol
protocol ChangeControllerDelegate{
  func changeController(controllerName: String)
}


class ContainerViewController: UIViewController{
  //当前的开关状态
  var currentState = State.Close
  //打开使用的遮罩层
  var maskView: UIView?
  var panGesture: UIPanGestureRecognizer?
  var tapGesture: UITapGestureRecognizer?
  
  var containerNavigationController = UINavigationController()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    //添加menuController
    let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
    let menuController = storyboard.instantiateViewControllerWithIdentifier("menu") as! MenuViewController
    addChildViewController(menuController)
    view.addSubview(menuController.view)
    menuController.delegate = self
    menuController.didMoveToParentViewController(self)
    
    //添加navigationController和它的viewControllers
    let controller = storyboard.instantiateViewControllerWithIdentifier(MenuItem.menuItems.first!.controllerName)
    var commenController = controller as! CommonController
    commenController.toggleDelegate = self
    addChildViewController(containerNavigationController)
    view.addSubview(containerNavigationController.view)
    containerNavigationController.didMoveToParentViewController(self)
    containerNavigationController.pushViewController(controller, animated: false)
    
    panGesture = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
    tapGesture = UITapGestureRecognizer(target: self, action: "handleTapGesture:")
    maskView = UIView(frame: CGRect(origin: containerNavigationController.view.frame.origin, size: CGSize(width: Config.menu_width, height: containerNavigationController.view.frame.height)))
    maskView?.addGestureRecognizer(tapGesture!)
    controller.view.addGestureRecognizer(panGesture!)
  }

}

extension ContainerViewController: ToggleControllerDelegate{
  
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
  func changeController(controllerName: String) {
    let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
    let controller = storyboard.instantiateViewControllerWithIdentifier(controllerName)
    let currentControllerName = "\(containerNavigationController.viewControllers.first!.dynamicType)"
    if currentControllerName != controllerName {
      containerNavigationController.setViewControllers([controller], animated: true)
      var commonController = controller as! CommonController
      commonController.toggleDelegate = self
      controller.view.addGestureRecognizer(panGesture!)
    }
    toggleMenu()
  }
}

