//
//  GeekTalkViewController.swift
//  GifApp
//
//  Created by 朱坤 on 11/26/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import UIKit

class GeekTalkViewController: UIViewController {
  @IBOutlet weak var postTable: UITableView!
  
  var posts: [Post]?{
    didSet{
      updateUI()
    }
  }
  
  override func viewDidLoad() {
    postTable.delegate = self
    postTable.dataSource = self
    Post.getData(){ data in
      self.posts = data
    }
  }
  
  func updateUI(){
    postTable.reloadData()
  }
}

extension GeekTalkViewController: UITableViewDataSource{
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return posts?.count ?? 0
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
    let cell = tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath) as! PostCell
    let post = posts?[indexPath.row]
    ImageUtil.convertImageToCircle(cell.avator)
    cell.setData(post, current_user_id: User.user?.id)
    return cell
  }
  
}

extension GeekTalkViewController: UITableViewDelegate{
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
}
