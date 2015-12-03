//
//  SpeechDetailViewController.swift
//  GifApp
//
//  Created by ScorpiusZ on 15/11/27.
//  Copyright © 2015年 Zkuns. All rights reserved.
//

import UIKit
import Kingfisher

class SpeechDetailViewController: UIViewController{
  
  var speech: Speech?
  var guest: Guest?

  @IBOutlet weak var titleLable: UILabel!
  @IBOutlet weak var themeLable: UILabel!
  @IBOutlet weak var showtimeLable: UILabel!
  @IBOutlet weak var speakerNameLable: UILabel!
  @IBOutlet weak var companyAndPositionLable: UILabel!
  @IBOutlet weak var descriptionLable: UILabel!
  @IBOutlet weak var avatorImageView: UIImageView!
  @IBOutlet weak var showdateLable: UILabel!
  @IBOutlet weak var backgroundView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateUI()
  }
  
  func updateUI(){
    title = speech?.title
    titleLable.text = speech?.title
    themeLable.text = speech?.theme
    showtimeLable.text = speech?.start_at_after_fomat("HH:mm")
    print(speech?.start_at)
    showdateLable.text = speech?.start_at_after_fomat("YYYY.MM.dd")
    speakerNameLable.text = guest?.name
    companyAndPositionLable.text = guest?.company
    descriptionLable.text = speech?.description
    backgroundView.backgroundColor = ColorConfig.greenColor
    avatorImageView.kf_setImageWithURL(NSURL(string: (guest?.avator ?? ""))!)
    ImageUtil.convertImageToCircle(self.avatorImageView)
    
    let image = UIImage(named: "collect_white")
    let button = UIButton(frame: CGRectMake(0, 0, (image?.size.width)!, (image?.size.height)!))
    button.setBackgroundImage(image, forState: .Normal)
//    button.addTarget(self, action: "", forControlEvents: UIControlEvents.TouchUpInside)
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    
    //给description添加背景框
    let bgConer = UIImage(named: "chat_coner")
    let bgImage = UIImageView(image: bgConer)
    bgImage.frame.origin = CGPoint(x: (backgroundView.frame.origin.x - 10), y: backgroundView.frame.origin.y - 25)
    view.addSubview(bgImage)
  }
  
}
