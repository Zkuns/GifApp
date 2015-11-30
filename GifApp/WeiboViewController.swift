//
//  WeiboViewController.swift
//  GifApp
//
//  Created by 朱坤 on 11/26/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import UIKit

class WeiboViewController: UIViewController{
  @IBOutlet weak var webView: UIWebView!

  override func viewDidLoad() {
    super.viewDidLoad()
    let reqUrl = NSURL(string: "http://weibo.com/geekpark")
    let request = NSURLRequest(URL: reqUrl!)
    webView.loadRequest(request)
  }
}
