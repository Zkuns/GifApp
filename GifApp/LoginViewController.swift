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

  @IBAction func showRegister(sender: AnyObject) {
    if let registerController = storyboard?.instantiateViewControllerWithIdentifier("register") as? UINavigationController{
      presentViewController(registerController, animated: true, completion: nil)
    }
  }
  
  func updateUI(){
    let tap = UITapGestureRecognizer(target: self, action: "disappearKeyBoard:")
    self.view.addGestureRecognizer(tap)
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
    SwiftSpinner.show("Authenticating user account")
    User.login(email, passwd: password){
      isSuccess,resultMsg in
      SwiftSpinner.hide()
      JLToast.makeText(resultMsg).show()
      self.disappear()
    }
    
  }

  @IBAction func close() {
    disappear()
  }
}

extension LoginViewController: UITextFieldDelegate{
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if textField == self.email{
      password.becomeFirstResponder()
    } else {
      textField.resignFirstResponder()
    }
    return true
  }
}

extension LoginViewController: UIGestureRecognizerDelegate{
  func disappearKeyBoard(recognizer: UITapGestureRecognizer){
    email.resignFirstResponder()
    password.resignFirstResponder()
  }
}
