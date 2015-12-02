//
//  UserCenterViewController.swift
//  GifApp
//
//  Created by 朱坤 on 11/29/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import UIKit

class UserCenterViewController: UIViewController {
  var index: Int?
  var qrImages: [String]?
  var posts: [Post]?
  var speeches: [Speech]?
  var user: User?
  var current_index: Int?{
    didSet{
      centerTable.reloadData()
    }
  }
  
  @IBOutlet weak var centerTable: UITableView!
  @IBOutlet weak var segment: UISegmentedControl!
  @IBOutlet weak var username: UILabel!
  @IBOutlet weak var avator: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    centerTable.delegate = self
    centerTable.dataSource = self
    User.getCurrentUser(){
      user in
      self.user = user
    }
  }
  
  func qrImageAPI(id: String) -> String{
    return "http://www.geekpark.net/qr/\(id)?download=1"
  }
}

extension UserCenterViewController: UITableViewDataSource{
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    if current_index == 0{
      return 1
    } else {
      return 1
    }
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
    if current_index == 0{
      return (user?.QRimage?.count) ?? 0
    } else {
      return (user?.collections?.count) ?? 0
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
    let cell = UITableViewCell()
    if current_index == 0{
      let cell = tableView.dequeueReusableCellWithIdentifier("qrCell", forIndexPath: indexPath) as! QrCell
      dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)){
        if let images = self.user?.QRimage{
          let imageData = NSData(contentsOfURL: NSURL(string: self.qrImageAPI(images[indexPath.row]))!)
          dispatch_async(dispatch_get_main_queue()){
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            if let cell = cell as? QrCell{
              if imageData != nil{
                cell.qrImage.image = UIImage(data: imageData!)!
              } else {
                cell.qrImage.image = nil
              }
            }
          }
        }
      }
    } else {
      let cell = tableView.dequeueReusableCellWithIdentifier("speechCell", forIndexPath: indexPath) as! SpeechCell
      cell.setData(Speech.find_by_id((user?.collections![indexPath.row])!))
    }
    return cell
  }
}

extension UserCenterViewController: UITableViewDelegate{
  
}