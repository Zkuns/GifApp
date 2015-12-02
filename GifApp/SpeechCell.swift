//
//  SpeechCell.swift
//  GifApp
//
//  Created by 朱坤 on 11/26/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import UIKit

class SpeechCell: UITableViewCell {
  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var guestName: UILabel!
  @IBOutlet weak var guestCompany: UILabel!
  @IBOutlet weak var guestTitle: UILabel!
  @IBOutlet weak var duration: UILabel!
  @IBOutlet weak var avator: UIImageView!
  
  func setData(speech: Speech){
    self.avator.image = nil
    title.text! = speech.title!
    duration.text! = speech.start_at_after_fomat("HH:mm")
    if let gu = speech.guest{
      guestName.text! = gu.name!
      guestCompany.text! = gu.company!
      guestTitle.text! = gu.title!
      dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)){
        if let imageUrl = gu.avator{
          let imageData = NSData(contentsOfURL: NSURL(string: imageUrl)!)
          dispatch_async(dispatch_get_main_queue()){
            if imageData != nil{
              ImageUtil.convertImageToCircle(self.avator)
              self.avator.image = UIImage(data: imageData!)!
            } else {
              self.avator.image = nil
            }
          }
        }
      }
      
    }
  }
}
