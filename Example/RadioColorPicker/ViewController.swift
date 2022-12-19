//
//  ViewController.swift
//  RadioColorPicker
//
//  Created by Wallaby on 12/19/2022.
//  Copyright (c) 2022 Wallaby. All rights reserved.
//

import UIKit
import RadioColorPicker

class ViewController: UIViewController {
  
  @IBOutlet weak var colorPicker: RadioColorPickerButton!
  @IBOutlet weak var selectedStateLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    colorPicker.delegate = self
  }
  
  @IBAction func didChangeBorderSpacingValue(_ sender: UISlider) {
    let value = sender.value
    colorPicker.borderSpacing = CGFloat(value)
  }
  
  @IBAction func didChangeBorderWidthValue(_ sender: UISlider) {
    let value = sender.value
    colorPicker.borderWidth = CGFloat(value)
  }
}

extension ViewController: RadioColorPickerButtonDelegate {
  func didChangeSelectedState(isSelected: Bool) {
    selectedStateLabel.text = isSelected ? "selected" : "Not selected"
  }
}
