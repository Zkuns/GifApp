//
//  SpeechViewController.swift
//  GifApp
//
//  Created by 朱坤 on 11/24/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import UIKit

class SpeechViewController: PageViewController {

  @IBOutlet weak var speechTable: UITableView!
  
  var currentSpeechType: Speech.SpeechType = Speech.SpeechType.User
  
  var speeches: [(String, [Speech])]? {
    didSet{ updateUI() }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  private func setupTableView() {
    speechTable.delegate = self
    speechTable.dataSource = self
    speechTable.separatorStyle = UITableViewCellSeparatorStyle.None
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    Speech.getSpeeches(currentSpeechType,index: itemIndex!){
      isSuccess,speeches in
      self.speeches = speeches
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
              if let speech = self.speeches?[index.section].1[index.row] {
                dvc.speech = speech
                dvc.guest = speech.guest
              }
            }
        }
      default:break
      }
    }
  }
    
}

extension SpeechViewController: UITableViewDataSource{
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return speeches?[section].0
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return speeches?.count ?? 0
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return speeches?[section].1.count ?? 0
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
    let cell = tableView.dequeueReusableCellWithIdentifier("speechCell", forIndexPath: indexPath) as! SpeechCell
    if let speech = speeches?[indexPath.section].1[indexPath.row] {
      ImageUtil.convertImageToCircle(cell.avator)
      cell.setData(speech)
      cell.collectedButton.tag = indexPath.row
    }
    if currentSpeechType == Speech.SpeechType.User{ cell.parentController = self }
    return cell
  }
  
}

extension SpeechViewController: UITableViewDelegate{
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
}