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
  var description: String? {
    get{
      return Ticket.descriptions[title]
    }
  }
  
  static private let descriptions = [
    "极客体验票":"注：极客体验票仅限于参与未来头条年度版和创新体验展。",
    "极客狂欢票":"注：极客狂欢票可以参与全部论坛，不确保有座。",
    "极客超级票":"注：极客超级票可以参与全部论坛，确保有座。",
  ]
  
  init(id: String, title: String){
    self.id = id
    self.title = title
  }
  
  func qrCode(size: CGSize) ->UIImage? {
    var qrCode = QRCode(id)
    qrCode?.size = size
    return qrCode?.image
  }
  
}
