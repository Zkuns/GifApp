//
//  MenuViewController.swift
//  GifApp
//
//  Created by 朱坤 on 11/24/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
  
  @IBOutlet weak var avator: UIImageView!
  @IBOutlet weak var username: UILabel!
  @IBOutlet weak var collection: UILabel!
  @IBOutlet weak var post: UILabel!
  @IBOutlet weak var loginArea: UIView!
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
                self.avator.image = UIImage(named: UserConfig.userLoginDefaultAvator)
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    menuTable.delegate = self
    menuTable.dataSource = self
    let moveToUserCenterCol = UITapGestureRecognizer(target: self, action: "moveToUserCenter:")
    let moveToUserCenterPost = UITapGestureRecognizer(target: self, action: "moveToUserCenter:")
    postArea.addGestureRecognizer(moveToUserCenterPost)
    collectionArea.addGestureRecognizer(moveToUserCenterCol)
    updataUI()
  }
  
  func reloadController(){
    self.viewDidLoad()
  }
  
  func updataUI(){
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
    postArea.layer.opacity = 1
    collectionArea.layer.opacity = 1
    username.text = user.username!
    collection.text = String(user.collections!.count)
    post.text = String(user.posts!.count)
    self.view.setNeedsDisplay()
  }
  
  private func updateHeaderWithoutUser(){
    let openLoginPage = UITapGestureRecognizer(target: self, action: "openLoginPage:")
    avator.image = UIImage(named: UserConfig.userNotLoginAvator)
    loginArea.addGestureRecognizer(openLoginPage)
    avator.userInteractionEnabled = true
    username.text = "请登陆"
    postArea.layer.opacity = 0
    collectionArea.layer.opacity = 0
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
    let cell = MenuCell()
    let menuModel = menuItems[indexPath.row]
    cell.setData(menuModel.menuName, imageName: menuModel.imageName)
    return cell
  }
}