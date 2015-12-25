//
//  GeekTalkViewController.swift
//  GifApp
//
//  Created by 朱坤 on 11/26/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import UIKit

protocol DetailImageDelegate{
  func openDetail(urls: [String]?, index: Int)
}

class GeekTalkViewController: BasicViewController {
  @IBOutlet weak var postTable: UITableView!
  var refreshControl: UIRefreshControl?
  var page = 1
  var hasMore: Bool = true
  
  var posts: [Post]?{
    didSet{
      updateUI()
    }
  }
  
  override func viewDidLoad() {
    initTableView()
    reloadData(1)
  }
  
  private func initTableView(){
    postTable.delegate = self
    postTable.dataSource = self
    refreshControl = UIRefreshControl()
    refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
    postTable.addSubview(refreshControl!)
    postTable.separatorStyle = UITableViewCellSeparatorStyle.None
  }
  
  func refresh(sender: AnyObject){
    self.hasMore = true
    page = 1
    Post.getData(page){ _, data in
      self.posts = data
      self.refreshControl?.endRefreshing()
      self.page += 1
    }
  }
  
  func updateUI(){
    postTable.reloadData()
  }
  
  func reloadData(page: Int){
    Post.getData(page){ refresh, data in
      if (data?.count ?? 0 < 3){ self.hasMore = false }
      if refresh {
        self.posts = data
        self.page = 1
      } else {
        self.posts = (self.posts ?? [Post]()) + (data ?? [Post]())
      }
      self.page += 1
    }
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
    if indexPath.row == ((posts?.count ?? 0 ) - 1) && (hasMore) {
      reloadData(page)
    }
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
    let postDetailViewController = storyboard?.instantiateViewControllerWithIdentifier("postDetailViewController") as! PostDetailViewController
    postDetailViewController.post = posts?[indexPath.row]
    postDetailViewController.detailImageDelegate = self
    self.navigationController?.pushViewController(postDetailViewController, animated: true)
  }
}

extension GeekTalkViewController: DetailImageDelegate{
  func openDetail(urls: [String]?, index: Int){
    if let controller = storyboard?.instantiateViewControllerWithIdentifier("imageContainerViewController") as? ImagePageViewController{
      controller.images = urls
      controller.currentPage = index
      self.presentViewController(controller, animated: true, completion: nil)
    }
  }
}