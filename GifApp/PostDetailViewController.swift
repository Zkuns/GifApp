//
//  PostDetailViewController.swift
//  GifApp
//
//  Created by 朱坤 on 12/23/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import UIKit

class PostDetailViewController: ApplicationViewController{
  @IBOutlet weak var commentTable: UITableView!
  var detailImageDelegate: DetailImageDelegate?
  @IBOutlet weak var commentText: UITextField!
  @IBOutlet weak var commentButton: UIButton!
  @IBOutlet weak var commentArea: UIView!
  var post: Post?
  var tap: UITapGestureRecognizer?
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
  }
  
  private func addNotification(){
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: "keyboardShown:", name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: "keyboardHide:", name: UIKeyboardWillHideNotification, object: nil)
  }
  
  private func updateUI(){
    if let post = post {
      Comment.getComments(post.id ?? ""){ success, comments in
        if success {
          self.comments = comments
        }
      }
    }
  }
  
  func keyboardShown(notification: NSNotification){
//    let info = notification.userInfo!
//    let value: AnyObject = info[UIKeyboardFrameEndUserInfoKey]!
//    let rawFrame = value.CGRectValue
//    let keyboardFrame = view.convertRect(rawFrame, fromView: nil)
//    print(keyboardFrame.height)
//    print(commentArea.frame.origin.y)
//    commentArea.frame.origin.y = commentArea.frame.origin.y - keyboardFrame.height - 200
//    print(commentArea.frame.origin.y)
    commentArea.frame.origin.y = 100
    print(commentArea.frame.origin)
    tap = UITapGestureRecognizer(target: self, action: "disappearKeyBoard:")
    self.view.addGestureRecognizer(tap!)
  }
  
  func keyboardHide(notification: NSNotification){
//    commentArea.frame.origin.y = UIScreen.mainScreen().bounds.height - commentArea.frame.height
//    commentArea.frame.origin.y = 200
    guard tap != nil else { return }
    self.view.removeGestureRecognizer(tap!)
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
  
}

extension PostDetailViewController: UIGestureRecognizerDelegate{
  func disappearKeyBoard(recognizer: UITapGestureRecognizer){
    commentText.resignFirstResponder()
  }
}