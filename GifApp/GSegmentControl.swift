//
//  GSegmentControl.swift
//  Pages
//
//  Created by ScorpiusZ on 15/12/3.
//  Copyright © 2015年 Geekpark. All rights reserved.
//

import UIKit

@IBDesignable class GSegmentControl: UIControl {
  
  private var labels = [GUILable]()
  var thumbView = UIView()
  
  var items: [String] = ["Item 1", "Item 2", "Item 3"] {
    didSet {
      setupLabels()
    }
  }
  
  var selectedIndex : Int = 0 {
    didSet {
      displayNewSelectedIndex()
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupView()
  }
  
  func setupView(){
    setupLabels()
    
    addIndividualItemConstraints(labels, mainView: self, padding: 0)
    
    insertSubview(thumbView, atIndex: 0)
  }
  
  func setupLabels(){
    for label in labels {
      label.removeFromSuperview()
    }
    labels.removeAll(keepCapacity: true)
    
    for index in 1...items.count {
      let label = customLabel(index)
      addSubview(label)
      labels.append(label)
    }
    addIndividualItemConstraints(labels, mainView: self, padding: 0)
  }
  
  func customLabel(index: Int) -> GUILable{
    let label = GUILable(frame: CGRectMake(0, 0, 70, 40))
    label.text = items[index - 1]
    label.backgroundColor = UIColor.clearColor()
    label.textAlignment = .Center
    label.font = UIFont(name: "Avenir-Black", size: 15)
    label.isSelected = index == 1
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }
  
  func displayNewSelectedIndex(){
    if selectedIndex > (labels.count - 1) || selectedIndex < 0 {
      return
    }
    for item in labels {
      item.isSelected = false
    }
    let label = labels[selectedIndex]
    label.isSelected = true
    
    UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: [], animations: {
      
      self.thumbView.frame = label.frame
      
      }, completion: nil)

  }
  
  func addIndividualItemConstraints(items: [GUILable], mainView: UIView, padding: CGFloat) {
    
    for (index, button) in items.enumerate() {
      
      let topConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: mainView, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0)
      
      let bottomConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: mainView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
      
      var rightConstraint : NSLayoutConstraint!
      
      if index == items.count - 1 {
        
        rightConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: mainView, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -padding)
        
      }else{
        
        let nextButton = items[index+1]
        rightConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: nextButton, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: -padding)
      }
      
      
      var leftConstraint : NSLayoutConstraint!
      
      if index == 0 {
        
        leftConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: mainView, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: padding)
        
      }else{
        
        let prevButton = items[index-1]
        leftConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: prevButton, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: padding)
        
        let firstItem = items[0]
        
        let widthConstraint = NSLayoutConstraint(item: button, attribute: .Width, relatedBy: NSLayoutRelation.Equal, toItem: firstItem, attribute: .Width, multiplier: 1.0  , constant: 0)
        
        mainView.addConstraint(widthConstraint)
      }
      
      mainView.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    var selectFrame = self.bounds
    let newWidth = CGRectGetWidth(selectFrame) / CGFloat(items.count)
    selectFrame.size.width = newWidth
    thumbView.frame = selectFrame
    thumbView.backgroundColor = UIColor.clearColor()
    
    displayNewSelectedIndex()
  }
  
  override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
    
    let location = touch.locationInView(self)
    
    var calculatedIndex : Int?
    for (index, item) in labels.enumerate() {
      if item.frame.contains(location) {
        calculatedIndex = index
      }
    }
    
    
    if calculatedIndex != nil {
      selectedIndex = calculatedIndex!
      sendActionsForControlEvents(.ValueChanged)
    }
    
    return false
  }

}
class GUILable: UILabel{
  var selectedColor = ColorConfig.greenColor
  var normalColor = ColorConfig.grayColor
  private let border = UIView()
  private let borderWidth = CGFloat(1)
  
  var isSelected: Bool=false{
    didSet{
      updateStyle()
    }
  }
  func updateStyle(){
    textColor = isSelected ? selectedColor : normalColor
    if isSelected{
      border.backgroundColor = selectedColor
      let y = self.frame.origin.y + self.frame.size.height - borderWidth
      border.frame = CGRectMake( 0 , y , self.frame.size.width, borderWidth)
      self.addSubview(border)
    }else{
      border.removeFromSuperview()
    }
  }
}