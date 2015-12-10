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
  @IBOutlet weak var collectedButton: UIButton!
  
  var speech: Speech? {
    didSet{
      updateUI()
    }
  }
  
  func updateUI() {
    avator.image = nil
    
    collectedButton.selected = speech?.isCollected ?? false
    title.text! = speech?.title ?? ""
    duration.text! = TimeUtil.fomatTime(speech?.start_at, form: "HH:mm")
    if let gu = speech?.guest{
      guestName.text! = gu.name!
      guestCompany.text! = gu.company!
      guestTitle.text! = gu.title!
      self.avator.kf_setImageWithURL(NSURL(string: gu.avator ?? "")!, placeholderImage: UIImage(named: "default_avator"))
    }
  }
  
  @IBAction func collectSpeech(sender: AnyObject) {
    speech?.isCollected = !(speech?.isCollected ?? false)
    updateUI()
  }
  
  func setData(speech: Speech){
    self.speech  = speech
  }
}
