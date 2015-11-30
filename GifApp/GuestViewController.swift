//
//  GuestViewController.swift
//  GifApp
//
//  Created by 朱坤 on 11/26/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import UIKit

class GuestViewController: UIViewController{
  @IBOutlet weak var guestTable: UITableView!
  
  var orderGuests = [(String, [Guest])](){
    didSet{
      guestTable.reloadData()
    }
  }
  
  override func viewDidLoad() {
    guestTable.delegate = self
    guestTable.dataSource = self
    Guest.getData(){ success, guests in
      if (success){
        self.orderGuests = guests!
      } else {
      }
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let indentifier = segue.identifier{
      switch indentifier{
      case "show_detail_from_guest":
        if let dvc = segue.destinationViewController as? SpeechDetailViewController{
          if let index = self.guestTable.indexPathForCell(sender as! GuestCell){
            let guest = orderGuests[index.section].1[index.row]
            dvc.guest = guest
            if let speech = guest.speech{
              dvc.speech = speech
            }
          }
        }
      default:break
      }
    }
  }
  
}

extension GuestViewController: UITableViewDelegate{
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
}

extension GuestViewController: UITableViewDataSource{
  
  func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
    let azchar = Array("abcedfghijklmnopqrstuvwxyz".characters)
    let azstr = azchar.map{ return String($0).uppercaseString }
    return azstr
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if orderGuests.count > 0{
      if orderGuests[section].1.count > 0{
        return orderGuests[section].0
      }
    }
    return nil
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 26
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if orderGuests.count > 0{
      return orderGuests[section].1.count
    } else {
      return 0
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("guestCell", forIndexPath: indexPath) as! GuestCell
    cell.avator.image = nil
    let guest = orderGuests[indexPath.section].1[indexPath.row]
    cell.setData(guest)
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)){
      if let imageUrl = guest.avator{
        let imageData = NSData(contentsOfURL: NSURL(string: imageUrl)!)
        dispatch_async(dispatch_get_main_queue()){
          let cell = tableView.cellForRowAtIndexPath(indexPath)
          if let cell = cell as? GuestCell{
            if imageData != nil{
              cell.avator.image = UIImage(data: imageData!)!
            } else {
              cell.avator.image = nil
            }
          }
        }
      }
    }
    return cell
  }
}