//
//  SpeechViewController.swift
//  GifApp
//
//  Created by 朱坤 on 11/24/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import UIKit

class SpeechViewController: UIViewController {

  @IBOutlet weak var speechTable: UITableView!
  
  @IBOutlet weak var toggleButton3: ToggleDayButton!
  @IBOutlet weak var toggleButton2: ToggleDayButton!
  @IBOutlet weak var toggleButton1: ToggleDayButton!
  var currentSpeeches: [Speech]?{
    didSet{
      if (self.currentSpeeches != nil){
        updateUI()
      }
    }
  }
  
  var currentIndex: Int?{
    didSet{
      currentSpeeches = self.speeches?[currentIndex!]
    }
  }
  
  var speeches: [[Speech]]? {
    didSet{
      currentIndex = 0
    }
  }
  
  @IBAction func toggleDay(sender: AnyObject) {
    if let tag = sender.tag{
      currentIndex = tag
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    ToggleDayButton.buttons = [toggleButton1, toggleButton2, toggleButton3]
    speechTable.delegate = self
    speechTable.dataSource = self
    
    let rightButton = UIBarButtonItem(title: "现场", style: UIBarButtonItemStyle.Done, target: nil, action: "")
    navigationItem.rightBarButtonItem = rightButton
    Speech.getData(){ success, speeches in
      if (success){
        self.speeches = speeches
      }
    }
  }
  
  func updateUI(){
    speechTable.reloadData()
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let indentifier = segue.identifier{
      switch indentifier{
        case "show_detail_from_speech":
          if let dvc = segue.destinationViewController as? SpeechDetailViewController{
            if let index = self.speechTable.indexPathForCell(sender as! SpeechCell){
              let speech = Speech.split(currentSpeeches!)[index.section][index.row]
              dvc.speech = speech
              dvc.guest = speech.guest
            }
        }
      default:break
      }
    }
  }
    
}

extension SpeechViewController: UITableViewDataSource{
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let cell = tableView.dequeueReusableCellWithIdentifier("speechHeader") as! SpeechHeader
    if (currentSpeeches != nil){
      cell.theme.text! = currentSpeeches![section].theme!
    }
    return cell.contentView
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if currentSpeeches?.count > 0{
      return Speech.split(currentSpeeches!)[section].count
    } else {
      return 0
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
    let cell = tableView.dequeueReusableCellWithIdentifier("speechCell", forIndexPath: indexPath) as! SpeechCell
    let speech = Speech.split(currentSpeeches!)[indexPath.section][indexPath.row]
    ImageUtil.convertImageToCircle(cell.avator)
    cell.setData(speech)
    return cell
  }
  
}

extension SpeechViewController: UITableViewDelegate{
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
}