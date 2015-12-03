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
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var wechatLoginButton: UIButton!
  @IBOutlet weak var closeButton: UIButton!
  

  override func viewDidLoad() {
    super.viewDidLoad()
    email.delegate = self
    password.delegate = self
    updateUI()
  }
  
  func updateUI(){
  }
  
  func selfDisappear(){
    self.view.removeFromSuperview()
    self.didMoveToParentViewController(nil)
    self.removeFromParentViewController()
  }
  
  @IBAction func login() {
    let email = self.email.text!
    let password = self.password.text!
//    User.login(email, passwd: password)
    User.login("zhaojunjie@geekpark.net", passwd: "geek_Zjj@901105,")
    selfDisappear()
  }
  
  @IBAction func loginWechat() {
    
  }
  
  @IBAction func close() {
    selfDisappear()
  }
}

extension LoginViewController: UITextFieldDelegate{
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
