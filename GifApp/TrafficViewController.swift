//
//  TrafficViewController.swift
//  GifApp
//
//  Created by 朱坤 on 11/26/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import UIKit

class TrafficViewController: UIViewController, CommonController{
  
  var toggleDelegate: ToggleControllerDelegate?
  
  override func viewDidLoad() {
    addNavigationBar()
  }
  
  func toggleMenu(sender: UIButton){
    toggleDelegate?.toggleMenu()
  }
  
  func addNavigationBar(){
    let image = UIImage(named: "menu")
    let button = UIButton(frame: CGRectMake(0, 0, (image?.size.width)!, (image?.size.height)!))
    button.setBackgroundImage(image, forState: .Normal)
    button.addTarget(self, action: "toggleMenu:", forControlEvents: UIControlEvents.TouchUpInside)
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
  }
}
