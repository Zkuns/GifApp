//
//  SpeechDetailViewController.swift
//  GifApp
//
//  Created by ScorpiusZ on 15/11/27.
//  Copyright © 2015年 Zkuns. All rights reserved.
//

import UIKit

class SpeechDetailViewController: UIViewController{
  
  var speech: Speech?

  @IBOutlet weak var titleLable: UILabel!
  @IBOutlet weak var themeLable: UILabel!
  @IBOutlet weak var showtimeLable: UILabel!
  @IBOutlet weak var speakerNameLable: UILabel!
  @IBOutlet weak var companyAndPositionLable: UILabel!
  @IBOutlet weak var descriptionLable: UILabel!
  @IBOutlet weak var avatarImageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateUI()
  }
  
  func updateUI(){
    title = speech?.title
    titleLable.text = speech?.title
    themeLable.text = speech?.theme
    showtimeLable.text = speech?.duration()
    speakerNameLable.text = speech?.guest?.name
    companyAndPositionLable.text = speech?.guest?.company
    descriptionLable.text = speech?.description
    updateAvatarImage()
  }
  
  func updateAvatarImage(){
    if let avatarUrl = speech?.guest?.avator {
      if let url = NSURL(string: avatarUrl){
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)){
          let imageData = NSData(contentsOfURL: url)
          dispatch_async(dispatch_get_main_queue()){
            if imageData != nil {
              self.avatarImageView.image = UIImage(data: imageData!)
            } else {
              self.avatarImageView.image = nil
            }
          }
        }
      }
    }
  }
}
