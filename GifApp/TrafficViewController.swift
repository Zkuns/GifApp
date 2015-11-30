//
//  TrafficViewController.swift
//  GifApp
//
//  Created by 朱坤 on 11/26/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import UIKit

struct Url{
  static let Gaode: NSString = "iosamap://poi?sourceApplication=com.zk.gif&backScheme=ZkunGif&name=751D·park北京时尚设计广场,79罐"
  static let Baidu: NSString = "baidumap://map/geocoder?address=北京798艺术区-C区"
  static let Default: NSString = "http://maps.apple.com/?ll=50.894967,4.341626"
}

class TrafficViewController: UIViewController{
  
  @IBAction func chooseMap(sender: UIButton) {
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
    alert.addAction(UIAlertAction(title: "高德", style: .Default, handler: {
      action in
      self.openMap(Url.Gaode)
    }))
    alert.addAction(UIAlertAction(title: "百度", style: .Default, handler: {
      action in
      self.openMap(Url.Baidu)
    }))
    alert.addAction(UIAlertAction(title: "自带地图", style: .Default, handler:{
      action in
      self.openMap(Url.Default)
    }))
    alert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
    presentViewController(alert, animated: true, completion: nil)
  }
  
  private func openMap(url: NSString){
    let urlStr : NSString = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())!
    let searchURL : NSURL = NSURL(string: urlStr as String)!
    if UIApplication.sharedApplication().canOpenURL(searchURL)
    {
      UIApplication.sharedApplication().openURL(searchURL)
    }
  }
}
