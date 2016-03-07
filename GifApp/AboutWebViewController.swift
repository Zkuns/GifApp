//
//  AboutWebViewController.swift
//  GifApp
//
//  Created by 朱坤 on 1/1/16.
//  Copyright © 2016 Zkuns. All rights reserved.
//

import UIKit

class AboutWebViewController: BasicViewController {
  @IBOutlet weak var webView: UIWebView!
  var content: String?{
    didSet{
      webView.loadHTMLString(content!, baseURL: nil)
    }
  }
  
  override func viewDidLoad() {
    Html.loadLocalHtmlString(){ str in
      self.content = str
    }
    Html.loadHtmlStringFromInternet(){ str in
      if let htmlString = str{
        self.content = htmlString
        Html.storeString(htmlString)
      }
    }
  }
  
}
