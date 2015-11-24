//
//  SpeechViewController.swift
//  GifApp
//
//  Created by 朱坤 on 11/24/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import UIKit

class SpeechViewController: UIViewController, CommonController{

  var toggleDelegate: ToggleControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let titleLabel = UILabel(frame: CGRectMake(0, 0, 20, (navigationController?.navigationBar.frame.height)!))
    titleLabel.text = "just test"
    let image = UIImage(named: "menu")
    let button = UIButton(frame: CGRectMake(0, 0, (image?.size.width)!, (image?.size.height)!))
    button.setBackgroundImage(image, forState: .Normal)
    button.addTarget(self, action: "toggleMenu:", forControlEvents: UIControlEvents.TouchUpInside)
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    navigationItem.titleView = titleLabel
  }
  
  func toggleMenu(sender: UIButton){
    toggleDelegate?.toggleMenu(nil, completion: nil)
  }
  
}
