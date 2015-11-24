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

protocol ToggleControllerDelegate{
  func toggleMenu(action: (()->())?, completion: ((Bool)->Void)?)
}
protocol CommonController{
  var toggleDelegate: ToggleControllerDelegate?{ get set }
  func toggleMenu(sender: UIButton)
}
class ContainerViewController: UIViewController{
  //当前的开关状态
  var currentState = State.Close
  var maskView: UIView?
  var containerNavigationController = UINavigationController()

  override func viewDidLoad() {
    super.viewDidLoad()
    let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
    let menuController = storyboard.instantiateViewControllerWithIdentifier("menu")
    addChildViewController(menuController)
    view.addSubview(menuController.view)
    menuController.didMoveToParentViewController(self)
    
    let speechController = storyboard.instantiateViewControllerWithIdentifier("speech") as! SpeechViewController
    speechController.toggleDelegate = self
    addChildViewController(containerNavigationController)
    view.addSubview(containerNavigationController.view)
    containerNavigationController.didMoveToParentViewController(self)
    containerNavigationController.pushViewController(speechController, animated: false)
    
    let panGesture = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
    let tapGesture = UITapGestureRecognizer(target: self, action: "handleTapGesture:")
    maskView = UIView(frame: CGRect(origin: containerNavigationController.view.frame.origin, size: CGSize(width: Config.menu_width, height: containerNavigationController.view.frame.height)))
    maskView?.addGestureRecognizer(tapGesture)
    containerNavigationController.view.addGestureRecognizer(panGesture)
  }

}

extension ContainerViewController: ToggleControllerDelegate{
  func toggleMenu(var action: (()->())? = nil, completion: ((Bool)->Void)? = nil){
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
    UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: action!, completion: completion)
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
          toggleMenu(nil, completion: nil)
        } else {
          currentState = .Open
          toggleMenu(nil, completion: nil)
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


