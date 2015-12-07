//
//  UserTicketsViewController.swift
//  GifApp
//
//  Created by ScorpiusZ on 15/12/3.
//  Copyright © 2015年 Zkuns. All rights reserved.
//

import UIKit

class UserTicketsViewController: PageViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
  }
  
  private func setupTableView(){
    tableView.delegate = self
    tableView.dataSource = self
  }
  
}

extension UserTicketsViewController: UITableViewDelegate{
  
}

extension UserTicketsViewController: UITableViewDataSource{
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("ticketCell", forIndexPath: indexPath) as! TicketCell
    // TODO:
    cell.ticket = Ticket(id: "\(indexPath.row)", title: "title \(indexPath.row)", description: "description : \(indexPath.row)")
    return cell
  }
  
}
