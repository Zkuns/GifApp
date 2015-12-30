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
  @IBOutlet weak var report_button: UIButton!
  
  var comment: Comment?
  
  func setDate(comment: Comment?){
    ImageUtil.convertImageToCircle(avator)
    name.text! = comment?.name ?? ""
    publish_at.text! = TimeUtil.timeAgo(comment?.publish_at)
    body.text! = comment?.body ?? ""
    avator.kf_setImageWithURL(NSURL(string: comment?.avator ?? "")!, placeholderImage: UIImage(named: "default_avator"))
    let title = comment!.reported ? "取消举报" : "举报"
    report_button.setTitle(title, forState: UIControlState.Normal)
    self.comment = comment
  }
  
  @IBAction func reportComment(sender: UIButton) {
    report_button.userInteractionEnabled = false
    comment?.uploadReportComment(){
      self.report_button.userInteractionEnabled = true
      self.report_button.setTitle(self.comment!.reported ? "取消举报":"举报", forState: .Normal)
    }
  }
  
  func getHeight() -> CGFloat{
    let constraint_height: CGFloat = 40
    let body_height = comment?.body?.boundingRectWithSize(CGSize(width:UIScreen.mainScreen().bounds.width-64, height: CGFloat(DBL_MAX)), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: body.font!, NSForegroundColorAttributeName: UIColor.redColor()], context: nil).height
    return constraint_height + name.frame.height + publish_at.frame.height + body_height!
  }
}
