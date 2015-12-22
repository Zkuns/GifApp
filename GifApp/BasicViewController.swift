//
//  BasicViewController.swift
//  GifApp
//
//  Created by 朱坤 on 12/18/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import UIKit

class BasicViewController: ApplicationViewController {

  var changeControllerDelegate: ChangeControllerDelegate?
  
  var afterLogin: AfterLogin?
  
  var menuItem: MenuItem?
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationItem.title = menuItem?.menuName
  }
  
  func changeControllerTo(menuItem: MenuItem){
    changeControllerDelegate?.changeController(menuItem)
  }
  
}
