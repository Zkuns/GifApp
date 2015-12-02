//
//  LoginViewController.swift
//  GifApp
//
//  Created by 朱坤 on 11/28/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
  @IBOutlet weak var email: UITextField!
  @IBOutlet weak var password: UITextField!
  @IBOutlet weak var modal: UIView!
  var updateUIDelegate: UpdateUIDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    modal.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.2)
  }
  
  func selfDisappear(){
    self.view.removeFromSuperview()
    self.didMoveToParentViewController(nil)
    self.removeFromParentViewController()
  }
  
  @IBAction func login() {
    let email = self.email.text!
    let password = self.password.text!
    User.getUserFromNetWork(email, password: password){ user in
      if let user = user{
        User.currentUser = user
        self.updateUIDelegate?.updateUIWithUser()
      }
    }
    selfDisappear()
  }
  
  @IBAction func loginWechat() {
    
  }
  
  @IBAction func closeButton() {
    selfDisappear()
  }
}
