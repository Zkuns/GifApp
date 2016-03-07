//
//  Config.swift
//  GifApp
//
//  Created by 朱坤 on 11/24/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import UIKit

struct Config {
  static let menu_width: CGFloat = 100
  static let menu_ratio: CGFloat = 0.7
  static let baseUrl: String = "http://events.geekpark.net"
  static let speechesAPI: String = "http://events.geekpark.net/api/v1/activities/663b2c7b-14c9-48bc-abaa-7810c6073168/speeches"
  //static let currentActivityId = "d345e8e8-f512-4192-8cb7-7aaf19f3a084"
//  static let currentActivityId: String = "663b2c7b-14c9-48bc-abaa-7810c6073168"
  static let currentActivityId: String = "20574418-948a-4f47-9c96-9247a5712a05"
}

struct LocalStorageKey {
  static let speechStoryKey = "localStorySpeechKey"
  static let guestStoryKey = "localStoryGuestKey"
}

struct LaunchConfig {
  static let screenImgName = "LauncheScreen"
}

struct UserConfig {
  static let userTokenKey = "UserToken"
  static let userNotLoginAvator = "cat"
  static let userLoginDefaultAvator = "cat"
  static let userRefreshKey = "UserRefreshToken"
}

struct OmniauthConfig {
  static let authenticateUrl: String = "http://www.geekpark.net"
  static let resoureUrl: String = "http://events.geekpark.net"
  static let client_id = "8947c399a016309c0fa36d84fed9bc332868546eca2ca38a16164e9b9fe2410b"
  static let client_secret = "4309b28598d4f938211129568cc80934c29e7cdc2b0e02faf5b9050761221cf4"
}

struct NotificationName{
  static let userSeted: String = "notification_user_seted"
  static let userRegisted: String = "notification_user_registed"
  static let userChanged: String = "notification_user_changed"
  static let userLogout: String = "notification_user_logout"
}

class PageViewController: UIViewController{
  var itemIndex: Int?
}
class UserCenterItems{
  static let items = [ SlidePageItem(title: "票据", controllerIdentifier: "UserTicketsViewController")
    , SlidePageItem(title: "收藏", controllerIdentifier: "SpeechViewController")
  ]
}

class SpeechesItems{
  static let items = [ SlidePageItem(title: "2016.01.15", controllerIdentifier: "SpeechViewController")
    , SlidePageItem(title: "2016.01.16", controllerIdentifier: "SpeechViewController")
    , SlidePageItem(title: "2016.01.17", controllerIdentifier: "SpeechViewController")
  ]
}
struct SlidePageItem {
  let title: String
  let controllerIdentifier: String
}

struct TrafficItem {
  let tagText: String
  let titleText: String
  let descriptionText: String
  let iconImage: UIImage
}

struct PostConfig{
  static let postLikeKey = "liked_post"
  static let reportCommentKey = "report_comment"
}

struct Default {
  static let avatar = "default_avator"
  static let menu_avatar = "menu_default_avator"
  static let image = "logo"
}

struct ColorConfig{
  static let greenColor = UIColor(red: 0.0, green: 170.0/255.0, blue: 173.0/255.0, alpha: 1.0)
  static let grayColor = UIColor(red: 160.0/255.0, green: 160.0/255.0, blue: 160.0/255.0, alpha: 1.0)
  static let yellowColor = UIColor(red: 253.0/255.0, green: 220.0/255.0, blue: 0, alpha: 1)
//  static let greenColor = UIColor(colorLiteralRed: 0, green: 170/255.0, blue: 173/255.0, alpha: 1)
}

struct AboutConfig{
  static let aboutHtmlKey = "aboutHtmlKey"
}