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
    avator.image = nil
  }
  
}
