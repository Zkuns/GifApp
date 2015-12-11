//
//  LoginViewController.swift
//  GifApp
//
//  Created by 朱坤 on 11/28/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import UIKit
import JLToast
import SwiftSpinner

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
    NSNotificationCenter.defaultCenter().addObserverForName(NotificationName.userRegisted, object: nil ,queue: NSOperationQueue.mainQueue()){
      notification in
      if let info = notification.userInfo as? Dictionary<String,String> {
        if let email = info["email"] {
          if let password = info["password"] {
            self.login(email, password: password)
          }
        }
      }
    }
    updateUI()
  }

  func updateUI(){
  }

  func disappear(){
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    appDelegate.window?.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
  }

  @IBAction func login() {
    let email = self.email.text!
    let password = self.password.text!
    login(email, password: password)
  }
  
  private func login(email: String, password: String){
    print("login: \(email) , \(password)")
    SwiftSpinner.show("Authenticating user account")
    User.login(email, passwd: password){
      isSuccess,resultMsg in
      SwiftSpinner.hide()
      JLToast.makeText(resultMsg).show()
      self.disappear()
    }
    
  }

  @IBAction func loginWechat() {
    
  }

  @IBAction func close() {
    disappear()
  }
}

extension LoginViewController: UITextFieldDelegate{
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
