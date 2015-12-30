//
//  ApplicationViewController.swift
//  GifApp
//
//  Created by 朱坤 on 12/19/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import UIKit

class ApplicationViewController: UIViewController{

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  func login(afterLoginDelegate: AfterLogin?, message: String? = nil){
    let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
    
    if let loginController = storyboard.instantiateViewControllerWithIdentifier("login") as? LoginViewController{
      loginController.loginDelegate = afterLoginDelegate
      loginController.message = message
      self.presentViewController(loginController, animated: true, completion: nil)
    }
  }
  
}
