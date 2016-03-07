//
//  PostDetailViewController.swift
//  GifApp
//
//  Created by 朱坤 on 12/23/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import UIKit
import RainbowSwift
import Toast

protocol ReportDelegate{
  func alertSure(callback: ()->())
  func showToast(message: String)
}

class PostDetailViewController: ApplicationViewController{
  @IBOutlet weak var commentTable: UITableView!
  var detailImageDelegate: DetailImageDelegate?
  @IBOutlet weak var commentArea: UIView!
  @IBOutlet weak var commentText: UITextView!
  @IBOutlet weak var commentHeight: NSLayoutConstraint!
  var post: Post?
  var tap: UITapGestureRecognizer?
  var openFromCommentButton: Bool = false
  var keyBoardHeight: CGFloat?
  var viewIsUp: Bool = false
  var comments: [Comment]? {
    didSet{
      commentTable.reloadData()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    commentTable.dataSource = self
    commentTable.delegate = self
    updateUI()
    addNotification()
    initMenuItem()
  }
  
  override func viewDidAppear(animated: Bool) {
    guard openFromCommentButton else { return }
    let postDetailCell = commentTable.dequeueReusableCellWithIdentifier("postDetailCell") as! PostDetailCell
    postDetailCell.setData(post)
    let height = postDetailCell.getHeight()
    if (commentTable.contentSize.height - height - UIScreen.mainScreen().bounds.height + 88 < 0) && (comments?.count > 0) {
      self.commentTable.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
    } else if comments?.count == 0 {
    } else {
      UIView.animateWithDuration(0.3, animations: { self.commentTable.contentOffset.y = height })
    }
  }
  
  private func initMenuItem(){
    let menuItem = UIMenuItem(title: "举报", action: "report:")
    UIMenuController.sharedMenuController().menuItems = [menuItem]
  }
  
  private func addNotification(){
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: "keyboardShown:", name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: "keyboardHide:", name: UIKeyboardWillHideNotification, object: nil)
  }
  
  private func updateUI(){
    commentText.delegate = self
    commentText.text = "字数不能大于140字"
    commentText.textColor = UIColor.lightGrayColor()
    if let post = post {
      Comment.getComments(post.id ?? ""){ success, comments in
        if success {
          self.comments = comments
        }
      }
    }
  }
  
  @IBAction func clickComment(sender: AnyObject) {
    let text = commentText.text
    if let message = Comment.checkText(text){
      self.view.makeToast(message, duration: 1, position: CSToastPositionCenter, style: nil)
      return
    }
    Comment.postComment(text, post_id: post?.id ?? ""){ success in
      if success {
        self.commentText.text = ""
        self.commentText.resignFirstResponder()
        self.view.makeToast("评论成功", duration: 1, position: CSToastPositionCenter, style: nil)
        Comment.getComments(self.post?.id ?? ""){ success, comments in
          if success {
            self.comments = comments
          }
        }
      } else {
        self.view.makeToast("网络连接失败请重新提交", duration: 1, position: CSToastPositionCenter, style: nil)
      }
    }
  }
  
  func keyboardShown(notification: NSNotification){
    let info = notification.userInfo!
    let value: AnyObject = info[UIKeyboardFrameEndUserInfoKey]!
    let rawFrame = value.CGRectValue
    let keyboardFrame = view.convertRect(rawFrame, fromView: nil)
    keyBoardHeight = keyboardFrame.height
    tap = UITapGestureRecognizer(target: self, action: "disappearKeyBoard:")
    self.view.addGestureRecognizer(tap!)
    if let height = keyBoardHeight {
      if (self.commentTable.contentSize.height >= UIScreen.mainScreen().bounds.height && !self.viewIsUp){
        self.viewIsUp = true
        commentTable.contentOffset.y += height
      }
      UIView.animateWithDuration(1, animations: {
        self.commentHeight.constant = -height
        self.view.layoutIfNeeded()
      })
      self.commentTable.contentSize.height += height
    }
  }
  
  func keyboardHide(notification: NSNotification){
    self.commentHeight.constant = 0
    if let height = keyBoardHeight {
      if self.viewIsUp {
        self.commentTable.contentOffset.y -= height
        self.viewIsUp = false
      }
      commentTable.contentSize.height -= height
    }
    if let tap = self.tap {
      self.view.removeGestureRecognizer(tap)
    }
  }
  
}

extension PostDetailViewController: UITableViewDelegate{
}

extension PostDetailViewController: UITableViewDataSource{
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard section == 1 else { return UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 0)) }
    let cell = tableView.dequeueReusableCellWithIdentifier("postDetailHeader") as! postDetailHeader
    cell.setData(comments?.count ?? 0)
    tableView.contentInset = UIEdgeInsetsMake(-cell.frame.height, 0, 0, 0);
    return cell.contentView
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if indexPath.section == 0{
      let postDetailCell = tableView.dequeueReusableCellWithIdentifier("postDetailCell") as! PostDetailCell
      postDetailCell.setData(post)
      return postDetailCell.getHeight()
    } else {
      let commentCell = tableView.dequeueReusableCellWithIdentifier("commentCell") as! CommentCell
      commentCell.setDate(comments?[indexPath.row])
      return commentCell.getHeight()
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if indexPath.section == 0{
      let postDetailCell = tableView.dequeueReusableCellWithIdentifier("postDetailCell") as! PostDetailCell
      postDetailCell.detailImageDelegate = detailImageDelegate
      postDetailCell.setData(post)
      return postDetailCell
    } else {
      let commentCell = tableView.dequeueReusableCellWithIdentifier("commentCell") as! CommentCell
      commentCell.setDate(comments?[indexPath.row])
      commentCell.reportDelegate = self
      return commentCell
    }
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return 1
    } else {
      guard let comments = comments else { return 0 }
      return comments.count
    }
  }
  
  func tableView(tableView: UITableView, shouldShowMenuForRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return indexPath.section == 1
  }
  
  func tableView(tableView: UITableView, canPerformAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
    if action.description == "report:"{
      return true
    }
    return false
  }
  
  func tableView(tableView: UITableView, performAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
  }
}

extension PostDetailViewController: UITextViewDelegate{
  func textViewDidBeginEditing(_: UITextView) {
    if User.access_token == nil{
      login(self, message: "请先登陆")
    }
    if commentText.text == "字数不能大于140字" {
      commentText.text = ""
      commentText.textColor = UIColor.blackColor()
    }
  }
  
  func textViewDidEndEditing(textView: UITextView) {
    if commentText.text == "" {
      commentText.text = "字数不能大于140字"
      commentText.textColor = UIColor.lightGrayColor()
    }
  }
}

extension PostDetailViewController: UIGestureRecognizerDelegate{
  func disappearKeyBoard(recognizer: UITapGestureRecognizer){
    commentText.resignFirstResponder()
  }
}

extension PostDetailViewController: AfterLogin{
  func onSuccess() {
    
  }
  
  func onFailed() {
    commentText.resignFirstResponder()
  }
}

extension PostDetailViewController: ReportDelegate{
  func alertSure(callback: () -> ()) {
    let alertController = UIAlertController(title: "确定举报？", message: nil, preferredStyle: .Alert)
    
    let cancelAction = UIAlertAction(title: "取消", style: .Cancel) { _ in }
    alertController.addAction(cancelAction)
    
    let OKAction = UIAlertAction(title: "确定", style: .Default) { _ in callback() }
    alertController.addAction(OKAction)
    
    self.presentViewController(alertController, animated: true) {}
  }
  
  func showToast(message: String) {
    self.view.makeToast(message, duration: 1.5, position: CSToastPositionCenter, style: nil)
  }
}