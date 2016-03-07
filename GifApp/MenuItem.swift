//
//  Menu.swift
//  GifApp
//
//  Created by 朱坤 on 11/24/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import Foundation

class MenuItem{
  var controllerName: String
  var menuName: String
  var imageName: String
  static let userCenterItem = MenuItem(controllerName: "UserViewController", menuName: "用户中心", imageName: "cat")
  static let speechItem = MenuItem(controllerName: "SpeechesViewController", menuName: "大会日程", imageName: "speech")
  static var menuItems: [MenuItem] = {
    var items: [MenuItem] = []
    items.append(MenuItem(controllerName: "SpeechesViewController", menuName: "大会日程", imageName: "speech"))
    items.append(MenuItem(controllerName: "GuestViewController", menuName: "演讲嘉宾", imageName: "guest" ))
    items.append(MenuItem(controllerName: "GeekTalkViewController", menuName: "新闻动态", imageName: "geektalk"))
    items.append(MenuItem(controllerName: "TrafficViewController", menuName: "交通指南", imageName:"traffic"))
    items.append(MenuItem(controllerName: "AboutWebViewController", menuName: "关于GIF", imageName: "about"))
    return items
  }()
  
  init(controllerName: String, menuName: String, imageName: String){
    self.controllerName = controllerName
    self.menuName = menuName
    self.imageName = imageName
  }
  
  static func titleForController(controlerName: String)-> String{
    return menuItems.filter(){ item in
      item.controllerName == controlerName
    }.first?.controllerName ?? ""
  }
}