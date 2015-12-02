//
//  MenuViewController.swift
//  GifApp
//
//  Created by 朱坤 on 11/24/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
  
  @IBOutlet weak var loginArea: UIView!
  @IBOutlet weak var avator: UIImageView!
  @IBOutlet weak var username: UILabel!
  @IBOutlet weak var collection: UILabel!
  @IBOutlet weak var post: UILabel!
  @IBOutlet weak var collectionArea: UIView!
  @IBOutlet weak var postArea: UIView!
  
  
  var avatorUrl: String?{
    didSet{
      if avatorUrl != nil{
        if let url = NSURL(string: avatorUrl!){
          dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)){
            let imageData = NSData(contentsOfURL: url)
            dispatch_async(dispatch_get_main_queue()){
              if imageData != nil {
                self.avator.image = UIImage(data: imageData!)
              } else {
                self.avator.image = UIImage(named: "default_avator")
              }
            }
          }
        }
      }
    }
  }
  
  var delegate: ChangeControllerDelegate?
  var openLoginPageDelegate: OpenLoginPageDelegate?
  @IBOutlet weak var menuTable: UITableView!
  let menuItems = MenuItem.menuItems
  var moveToUserCenterCol: UITapGestureRecognizer?
  var moveToUserCenterPost: UITapGestureRecognizer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    menuTable.delegate = self
    menuTable.dataSource = self
    updataUI()
  }
  
  func reloadController(){
    self.viewDidLoad()
  }
  
  func updataUI(){
    ImageUtil.convertImageToCircle(avator)
    menuTable.separatorStyle = UITableViewCellSeparatorStyle.None
    if let user = User.currentUser{
      updataHeaderWithUser(user)
    } else {
      updateHeaderWithoutUser()
    }
  }
  
  //太恶心了,求指点
  private func updataHeaderWithUser(user: User){
    let moveToUserCenterQR = UITapGestureRecognizer(target: self, action: "moveToUserCenter:")
    loginArea.addGestureRecognizer(moveToUserCenterQR)
    avatorUrl = user.avator
    username.text = user.username!
    collection.text = String(user.collections!.count)
    post.text = String(user.posts!.count)
    self.view.setNeedsDisplay()
    moveToUserCenterCol = UITapGestureRecognizer(target: self, action: "moveToUserCenter:")
    moveToUserCenterPost = UITapGestureRecognizer(target: self, action: "moveToUserCenter:")
    postArea.addGestureRecognizer(moveToUserCenterPost!)
    collectionArea.addGestureRecognizer(moveToUserCenterCol!)
  }
  
  private func updateHeaderWithoutUser(){
    let openLoginPage = UITapGestureRecognizer(target: self, action: "openLoginPage:")
    avator.image = UIImage(named: "default_avator")
    loginArea.addGestureRecognizer(openLoginPage)
    username.text = "登陆"
    if moveToUserCenterCol != nil {
      postArea.removeGestureRecognizer(moveToUserCenterCol!)
      collectionArea.removeGestureRecognizer(moveToUserCenterCol!)
    }
  }
  
}

extension MenuViewController: UIGestureRecognizerDelegate{
  func moveToUserCenter(recogizer: UIPanGestureRecognizer){
    let view = recogizer.view
    delegate?.changeToUserCenterController(view!.tag)
  }
  
  func openLoginPage(recogizer: UIPanGestureRecognizer){
    openLoginPageDelegate?.openLoginPage()
  }
}

extension MenuViewController: UITableViewDelegate{
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    delegate?.changeController(menuItems[indexPath.row])
  }
}

extension MenuViewController: UITableViewDataSource{
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return menuItems.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
    let cell = tableView.dequeueReusableCellWithIdentifier("menuCell", forIndexPath: indexPath) as! MenuCell
    let menuModel = menuItems[indexPath.row]
    cell.setData(menuModel.menuName, imageName: menuModel.imageName)
    let bgColorView = UIView()
    bgColorView.backgroundColor = ColorConfig.yellowColor.colorWithAlphaComponent(0.8)
    cell.selectedBackgroundView = bgColorView
    return cell
  }
}