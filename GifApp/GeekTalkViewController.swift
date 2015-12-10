//
//  GeekTalkViewController.swift
//  GifApp
//
//  Created by 朱坤 on 11/26/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import UIKit

protocol DetailImageDelegate{
//  func openDetail(images_url: [String])
  func openDetail(url: String)
}

class GeekTalkViewController: UIViewController {
  @IBOutlet weak var postTable: UITableView!
  
  var posts: [Post]?{
    didSet{
      updateUI()
    }
  }
  
  override func viewDidLoad() {
    initTableView()
    Post.getData(){ data in
      self.posts = data
      print(self.posts)
    }
  }
  
  private func initTableView(){
    postTable.delegate = self
    postTable.dataSource = self
    postTable.estimatedRowHeight = postTable.rowHeight
//    postTable.rowHeight = UITableViewAutomaticDimension
//    postTable.separatorStyle = UITableViewCellSeparatorStyle.None
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
    cell.detailImageDelegate = self
    cell.setData(post)
    return cell
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    let cell = tableView.dequeueReusableCellWithIdentifier("postCell") as! PostCell
    cell.setData(posts?[indexPath.row])
    return cell.getRowHeight()
  }
  
}

extension GeekTalkViewController: UITableViewDelegate{
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
}

extension GeekTalkViewController: DetailImageDelegate{
  func openDetail(url: String){
    if let controller = storyboard?.instantiateViewControllerWithIdentifier("imageDetail") as? ImageDetailController{
      dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)){
        let data = NSData(contentsOfURL: NSURL(string: url)!)
        dispatch_async(dispatch_get_main_queue()){
          let image = UIImage(data: data!)!
          controller.image = image
          self.presentViewController(controller, animated: true, completion: nil)
        }
      }
    }
  }
}

//extension GeekTalkViewController: DetailImageDelegate{
//  func openDetail(images_url: [String]){
//    if let controller = storyboard?.instantiateViewControllerWithIdentifier("imageDetail") as? ImageDetailController{
//      dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)){
//        let imagesData = images_url.map{ url in
//          NSData(contentsOfURL: NSURL(string: url)!)
//        }
//        dispatch_async(dispatch_get_main_queue()){
//          let images = imagesData.map{ imageData -> UIImage in
//            if let data = imageData{
//              return UIImage(data: data)!
//            }
//            return UIImage()
//          }
//          controller.pageImages = images
//          self.presentViewController(controller, animated: true, completion: nil)
//        }
//      }
//    }
//  }
//}
