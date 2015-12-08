//
//  TraficItemView.swift
//  GifApp
//
//  Created by ScorpiusZ on 15/12/8.
//  Copyright © 2015年 Zkuns. All rights reserved.
//

import UIKit

class TrafficCell: UITableViewCell {
  
  @IBOutlet weak var tagLalble: UILabel!
  @IBOutlet weak var titleLable: UILabel!
  @IBOutlet weak var descriptionLable: UILabel!
  @IBOutlet weak var iconBgView: UIView!
  @IBOutlet weak var iconImageView: UIImageView!
  
  var trafficItem: TrafficItem? {
    didSet{
      updateUI()
    }
  }
  
  private func updateUI() {
    tagLalble.text = trafficItem?.tagText
    titleLable.text = trafficItem?.titleText
    descriptionLable.text = trafficItem?.descriptionText
    iconImageView.image = trafficItem?.iconImage
    iconBgView.layer.cornerRadius = iconBgView.frame.size.width/2
    iconBgView.clipsToBounds = true
  }
  
}
