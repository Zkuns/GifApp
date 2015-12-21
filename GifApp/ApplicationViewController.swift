//
//  ApplicationViewController.swift
//  GifApp
//
//  Created by 朱坤 on 12/19/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import UIKit

class ApplicationViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  func needLoginTo(callback: (()->())?){
    User.getCurrentUser(){ user in
      if user != nil{
        callback?()
      } else {
        if let loginController = self.storyboard?.instantiateViewControllerWithIdentifier("login") as? LoginViewController{
          loginController.callback = callback
          self.presentViewController(loginController, animated: true, completion: nil)
        }
      }
    }
    
  }
  

    
}
