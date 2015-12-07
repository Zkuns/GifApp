//
//  Ticket.swift
//  GifApp
//
//  Created by ScorpiusZ on 15/12/7.
//  Copyright © 2015年 Zkuns. All rights reserved.
//

import Foundation
import QRCode

class Ticket {
  
  let id:String
  let title:String
  let description: String
  
  init(id: String, title: String, description: String){
    self.id = id
    self.title = title
    self.description = description
  }
  
  func qrCode(size: CGSize) ->UIImage? {
    var qrCode = QRCode(id)
    qrCode?.size = size
    return qrCode?.image
  }
  
}
