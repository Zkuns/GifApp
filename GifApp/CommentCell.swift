//
//  CommentCell.swift
//  GifApp
//
//  Created by 朱坤 on 12/24/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
  @IBOutlet weak var avator: UIImageView!
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var publish_at: UILabel!
  @IBOutlet weak var body: UILabel!
  var comment: Comment?
  
  func setDate(comment: Comment?){
    ImageUtil.convertImageToCircle(avator)
    name.text! = comment?.name ?? ""
    publish_at.text! = TimeUtil.fomatTime(comment?.publish_at, form: "HH:mm")
    body.text! = comment?.body ?? ""
    avator.kf_setImageWithURL(NSURL(string: comment?.avator ?? "")!, placeholderImage: UIImage(named: "default_avator"))
    self.comment = comment
  }
  
  func getHeight() -> CGFloat{
    let constraint_height: CGFloat = 40
    let body_height = comment?.body?.boundingRectWithSize(CGSize(width:UIScreen.mainScreen().bounds.width-64, height: CGFloat(DBL_MAX)), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: body.font!, NSForegroundColorAttributeName: UIColor.redColor()], context: nil).height
    return constraint_height + name.frame.height + publish_at.frame.height + body_height!
  }
}
