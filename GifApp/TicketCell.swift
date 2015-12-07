//
//  TicketCell.swift
//  GifApp
//
//  Created by ScorpiusZ on 15/12/3.
//  Copyright © 2015年 Zkuns. All rights reserved.
//

import UIKit

class TicketCell: UITableViewCell {
  
  
  @IBOutlet weak var qrCodeImage: UIImageView!
  @IBOutlet weak var titleLable: UILabel!
  @IBOutlet weak var descLable: UILabel!
  
  var ticket: Ticket? {
    didSet{
      updateUI()
    }
  }
  
  private func updateUI(){
    titleLable.text = ticket?.title
    descLable.text = ticket?.description
    qrCodeImage.image = ticket?.qrCode(qrCodeImage.bounds.size)
  }

}
