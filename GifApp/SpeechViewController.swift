//
//  SpeechViewController.swift
//  GifApp
//
//  Created by 朱坤 on 11/24/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import UIKit

enum Day{
  case First, Second, Third
}

class SpeechViewController: UIViewController {

  @IBOutlet weak var speechTable: UITableView!
  
  var currentSpeeches: [Speech]?{
    didSet{
      if (self.currentSpeeches != nil){
        updateUI()
      }
    }
  }
  
  var currentState: Day?{
    set{
      currentDay = newValue!
      switch self.currentDay!{
      case .First: currentSpeeches = self.speeches![0]
      case .Second: currentSpeeches = self.speeches![1]
      case .Third: currentSpeeches = self.speeches![2]
      }
    }
    get{
      return currentDay
    }
  }
  
  var currentDay: Day?
  
  var speeches: [[Speech]]? {
    didSet{
      currentState = .First
    }
  }
  
  @IBAction func toggleDay(sender: UISegmentedControl) {
    let index = sender.selectedSegmentIndex
    let selectDay: Day = [.First, .Second, .Third][index]
    print (selectDay)
    if (currentState == nil || selectDay != currentState!){
      currentState = selectDay
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    speechTable.delegate = self
    speechTable.dataSource = self
    Speech.getData(self)
  }
  
  func updateUI(){
    speechTable.reloadData()
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    print("prepareForSegue")
    if let indentifier = segue.identifier{
      switch indentifier{
        case "show_detail_from_speech":
          if let dvc = segue.destinationViewController as? SpeechDetailViewController{
            if let index = self.speechTable.indexPathForCell(sender as! SpeechCell){
              let speech = speeches![index.section][index.row]
              print("\(speech)")
              dvc.speech = speech
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
      cell.theme.text! = section == 0 ? "\(currentSpeeches![0].theme ?? "") 上午" : "\(currentSpeeches![1].theme ?? "") 下午"
    }
    cell.location.text! = "地点"
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
    cell.setData(speech)
    return cell
  }
  
}

extension SpeechViewController: UITableViewDelegate{
}