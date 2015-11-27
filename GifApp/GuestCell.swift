//
//  GuestCell.swift
//  GifApp
//
//  Created by 朱坤 on 11/27/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import UIKit

class GuestCell: UITableViewCell {
  @IBOutlet weak var avator: UIImageView!
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var company: UILabel!
  @IBOutlet weak var title: UILabel!
  
  func setData(guest: Guest){
    name.text = guest.name
    company.text = guest.company
    title.text = guest.title
    avatorUrl = guest.avator
  }
  
  var avatorUrl: String?{
    didSet{
      if avatorUrl != nil{
        loadImage()
      }
    }
  }
  
  func loadImage(){
    if let url = avatorUrl{
      dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)){
        let imageData = NSData(contentsOfURL: NSURL(string: url)!)
        dispatch_async(dispatch_get_main_queue()){
          if imageData != nil{
            self.avator.image = UIImage(data: imageData!)!
          } else {
            self.avator.image = nil
          }
        }
      }
    }
  }
}
