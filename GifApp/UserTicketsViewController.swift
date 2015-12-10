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
  
  private var tickets = [Ticket](){
    didSet{
     tableView.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
    tickets = User.user?.tickets ?? []
  }
  
  private func setupTableView(){
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorStyle = UITableViewCellSeparatorStyle.None
  }
  
}

extension UserTicketsViewController: UITableViewDelegate{
  
}

extension UserTicketsViewController: UITableViewDataSource{
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tickets.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("ticketCell", forIndexPath: indexPath) as! TicketCell
    cell.ticket = tickets[indexPath.row]
    return cell
  }
  
}
