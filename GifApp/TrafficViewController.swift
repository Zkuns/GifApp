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
  static let Baidu: NSString = "baidumap://map/geocoder?address=751D·park北京时尚设计广场,79罐"
  static let Default: NSString = "http://maps.apple.com/?daddr=北京79罐"
}

class TrafficViewController: BasicViewController{
  
  @IBOutlet weak var trafficTable: UITableView!
  
  private var trafficItems: [TrafficItem]?
  
  @IBAction func chooseMap(sender: UIButton) {
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
    if UIApplication.sharedApplication().canOpenURL(NSURL(string: "iosamap://")!){
      alert.addAction(UIAlertAction(title: "高德", style: .Default, handler: {
        action in
        self.openMap(Url.Gaode)
      }))
    }
    if UIApplication.sharedApplication().canOpenURL(NSURL(string: "baidumap://")!){
      alert.addAction(UIAlertAction(title: "百度", style: .Default, handler: {
        action in
        self.openMap(Url.Baidu)
      }))
    }
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
    UIApplication.sharedApplication().openURL(searchURL)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initTableView()
    trafficItems = [
      TrafficItem(tagText: "地址",titleText: "751北京时尚设计广场79罐", descriptionText: "北京市朝阳区酒仙桥路4号（北京中关村电子城高新技术产业园区北京正东创意产业园内）", iconImage: UIImage(named: "traffic_addr_icon")!),
      TrafficItem(tagText: "地址",titleText: "751北京时尚设计广场79罐", descriptionText: "北京市朝阳区酒仙桥路4号（北京中关村电子城高新技术产业园区北京正东创意产业园内）", iconImage: UIImage(named: "traffic_addr_icon")!),
      TrafficItem(tagText: "交通",titleText: "自驾亦可 园区内有免费停车位", descriptionText: "北京电机总厂站（公交403、629路)彩虹路站（公交909、688、955、418、946、402路 ；下车后步行300米）", iconImage: UIImage(named: "traffic_routes_icon")!),
      TrafficItem(tagText: "餐饮",titleText: "价格适中 有多样选择", descriptionText: "751D·PARK北京时尚设计广场、798艺术区之中和周边有诸多中西餐厅、酒吧、茶餐厅等", iconImage: UIImage(named: "traffic_eat_icon")!)
    ]
  }
  
  private func initTableView() {
    trafficTable.delegate = self
    trafficTable.dataSource = self
    trafficTable.separatorStyle = UITableViewCellSeparatorStyle.None
    trafficTable.layer.shouldRasterize = true
    // No setting rasterizationScale, will cause blurry images on retina.
    trafficTable.layer.rasterizationScale = UIScreen.mainScreen().scale
  }
  
}

extension TrafficViewController: UITableViewDelegate {
  
}

extension TrafficViewController: UITableViewDataSource {
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if indexPath.row == 0{
      return 240
    } else {
      return 100
    }
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return trafficItems?.count ?? 0 + 1
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if indexPath.row == 0 {
      let cell = tableView.dequeueReusableCellWithIdentifier("trafficHeader")
      return cell!
    }
    let cell = tableView.dequeueReusableCellWithIdentifier("TrafficCell", forIndexPath: indexPath) as! TrafficCell
    cell.trafficItem = trafficItems?[indexPath.row]
    return cell
  }
  
}

