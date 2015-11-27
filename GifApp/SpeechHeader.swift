//
//  SpeechHeader.swift
//  GifApp
//
//  Created by 朱坤 on 11/26/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import UIKit

class SpeechHeader: UITableViewCell {
  @IBOutlet weak var theme: UILabel!
  @IBOutlet weak var location: UILabel!
  func setData(theme: String, location: String){
    self.theme.text! = theme
    self.location.text! = location
  }
}
