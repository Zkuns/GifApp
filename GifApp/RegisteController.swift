//
//  RegisteController.swift
//  GifApp
//
//  Created by ScorpiusZ on 15/12/11.
//  Copyright © 2015年 Zkuns. All rights reserved.
//

import UIKit
import SwiftSpinner

class RegisteController: UIViewController, UIWebViewDelegate {

  @IBOutlet weak var webView: UIWebView!
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Plain, target: self, action: "disappear:")
    webView.delegate = self
    webView.loadRequest(NSURLRequest(URL: NSURL(string: "http://www.geekpark.net/users/signup?show=false&platform=ios")!))
  }
  
  
  func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
    print("didFailLoadWithError = \(error?.description)")
  }
  
  func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
    if let url = request.URL {
      handleCurrentUrl(url)
    }
    return true
  }
  
  func disappear(sender: AnyObject){
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    appDelegate.window?.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    SwiftSpinner.show("loading")
  }
  
  func webViewDidFinishLoad(webView: UIWebView) {
    SwiftSpinner.hide()
  }
  
  private func handleCurrentUrl(url: NSURL){
    print("handleCurrentUrl \(url.absoluteString)")
    if url.absoluteString.containsString("/loginsuccess?"){
      if let query = url.query {
        var email = ""
        var password = ""
        for keyValueString in query.componentsSeparatedByString("&") {
          var parts = keyValueString.componentsSeparatedByString("=")
          if parts.count < 2 { continue; }
          print(parts)
          if parts[0].stringByRemovingPercentEncoding! == "email"{
            email = parts[1].stringByRemovingPercentEncoding!
          }
          if parts[0].stringByRemovingPercentEncoding! == "password"{
            password = parts[1].stringByRemovingPercentEncoding!
          }
        }
        loginSuccess(email, password: password)
      }
    }
  }
  
  private func loginSuccess(email: String,password: String){
    print("email = \(email) , password = \(password)")
    let data = ["email":email,"password":password]
    NSNotificationCenter.defaultCenter().postNotificationName(NotificationName.userRegisted, object: nil, userInfo: data)
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    appDelegate.window?.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
  }
  
}
