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
  
  func setData(speech: Speech){
    title.text! = speech.title!
    duration.text! = speech.duration()
    if let gu = speech.guest{
      guestName.text! = gu.name!
      guestCompany.text! = gu.company!
      guestTitle.text! = gu.title!
    }
  }
}
