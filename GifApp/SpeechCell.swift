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
    guestName.text! = speech?.guest?.name ?? ""
    guestCompany.text! = speech?.guest?.company ?? ""
    guestTitle.text! = speech?.guest?.title ?? ""
    self.avator.kf_setImageWithURL(NSURL(string: speech?.guest?.avator ?? "")!, placeholderImage: UIImage(named: "default_avator"))
  }
  
  @IBAction func collectSpeech(sender: AnyObject) {
    speech?.isCollected = !(speech?.isCollected ?? false)
    updateUI()
  }
  
  func setData(speech: Speech){
    self.speech  = speech
  }
}
