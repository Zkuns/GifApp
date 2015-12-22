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

protocol AfterLogin{
  func onSuccess()
  func onFailed()
}

class LoginViewController: UIViewController {
  @IBOutlet weak var email: UITextField!
  @IBOutlet weak var password: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var closeButton: UIButton!
  var keyboardHeight: CGFloat?
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var container: UIView!
  var isShow: Bool = false
  var loginDelegate: AfterLogin?
  
  var callback: (()->())?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    email.delegate = self
    password.delegate = self
    self.view.frame.origin.y -= 100
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: "keyboardShown:", name: UIKeyboardDidShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: "keyboardHide:", name: UIKeyboardDidHideNotification, object: nil)
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
      if !self.isShow { JLToast.makeText(resultMsg,duration: JLToastDelay.ShortDelay).show() }
      if isSuccess {
        self.isShow = true
        self.disappear()
      }
    }
  }

  @IBAction func close() {
    loginDelegate?.onFailed()
    disappear()
  }
  
  func keyboardShown(notification: NSNotification) {
    let info  = notification.userInfo!
    let value: AnyObject = info[UIKeyboardFrameEndUserInfoKey]!
    let rawFrame = value.CGRectValue
    let keyboardFrame = view.convertRect(rawFrame, fromView: nil)
    keyboardHeight = keyboardFrame.size.height
    viewUp()
  }
  
  func keyboardHide(notification: NSNotification){
    viewDown()
  }
  
  func viewUp(){
    scrollView.contentSize.height = container.frame.height + (keyboardHeight ?? 0)
    let resultHeight = calculate(keyboardHeight ?? 0)
    UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: {
      self.scrollView.contentOffset = CGPoint(x: 0, y: resultHeight)
    }, completion: nil)
  }
  
  func viewDown(){
    UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: {
      self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
    }, completion: nil)
    scrollView.contentSize.height = container.frame.height - (keyboardHeight ?? 0)
  }
  
  private func calculate(keyboardHeight: CGFloat) -> CGFloat{
    let visibleArea = UIScreen.mainScreen().bounds.height - keyboardHeight
    let needvisible = loginButton.frame.origin.y
    if visibleArea <= needvisible {
      return needvisible - visibleArea
    } else {
      return 0
    }
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
