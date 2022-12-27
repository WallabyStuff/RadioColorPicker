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
  
  // MARK: - UI
  
  @IBOutlet weak var controlContainerView: UIView!
  @IBOutlet weak var radioColorPicker: RadioColorPicker!
  @IBOutlet weak var addColorButton: UIButton!
  @IBOutlet weak var removeColorButton: UIButton!
  @IBOutlet weak var selectedColorIndicatorLabel: UILabel!
  
  
  // MARK: - LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  
  // MARK: - Setups
  
  private func setup() {
    setupView()
  }
  
  private func setupView() {
    setupControlContainerView()
    setupAddColorButton()
    setupRemoveColorButton()
    setupRadioColorPicker()
  }
  
  private func setupControlContainerView() {
    controlContainerView.layer.cornerRadius = 24
    controlContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    controlContainerView.layer.shadowColor = UIColor.black.cgColor
    controlContainerView.layer.shadowOpacity = 0.1
    controlContainerView.layer.shadowOffset = .zero
    controlContainerView.layer.shadowRadius = 20
  }
  
  private func setupAddColorButton() {
    addColorButton.layer.cornerRadius = 24
  }
  
  private func setupRemoveColorButton() {
    removeColorButton.layer.cornerRadius = 24
    removeColorButton.layer.borderWidth = 1
    removeColorButton.layer.borderColor = UIColor.systemRed.cgColor
  }
  
  private func setupRadioColorPicker() {
    radioColorPicker.addColor(.systemRed)
    radioColorPicker.addColor(.systemOrange)
    radioColorPicker.addColor(.systemYellow)
    radioColorPicker.addColor(.systemGreen)
    radioColorPicker.addColor(.systemBlue)
    radioColorPicker.addColor(.systemPurple)
    
    radioColorPicker.contentInset = .init(top: 20, leading: 24, bottom: 0, trailing: 24)
    radioColorPicker.delegate = self
  }

  
  // MARK: - Actions
  
  @IBAction func didTapAddColorButton(_ sender: Any) {
    let colors: [UIColor] = [.systemRed, .systemOrange,. systemYellow, .systemGreen, .systemBlue, .systemPurple, .systemGray]
    radioColorPicker.addColor(colors.randomElement()!)
  }
  
  @IBAction func didTapRemoveColorButton(_ sender: Any) {
    radioColorPicker.removeColor()
  }
  
  @IBAction func didChangeScrollDirectionValue(_ sender: UISegmentedControl) {
    if sender.selectedSegmentIndex == 0 {
      radioColorPicker.scrollDirection = .horizontal
    } else {
      radioColorPicker.scrollDirection = .vertical
    }
  }
  
  @IBAction func didChangeMultipleSelectionValue(_ sender: UISwitch) {
    if sender.isOn {
      radioColorPicker.allowsMultipleSelection = true
    } else {
      radioColorPicker.allowsMultipleSelection = false
    }
  }
  
  @IBAction func didChangeHorizontalSpacingValue(_ sender: UISlider) {
    let value = CGFloat(sender.value)
    radioColorPicker.horizontalSpacing = value
  }
  
  @IBAction func didChangeVerticalSpacingValue(_ sender: UISlider) {
    let value = CGFloat(sender.value)
    radioColorPicker.verticalSpacing = value
  }
  
  @IBAction func didChangePickerBorderWidthValue(_ sender: UISlider) {
    let value = CGFloat(sender.value)
    radioColorPicker.borderWidth = value
  }
  
  @IBAction func didChangePickerBorderSpacingValue(_ sender: UISlider) {
    let value = CGFloat(sender.value)
    radioColorPicker.borderSpacing = value
  }
}

extension ViewController: RadioColorPickerDelegate {
  func didItemSelected(index: Int, color: UIColor) {
    selectedColorIndicatorLabel.text = "Selected Indices\n\(radioColorPicker.selectedIndices)"
  }
  
  func didItemDeselected(index: Int, color: UIColor) {
    selectedColorIndicatorLabel.text = "Selected Indices\n\(radioColorPicker.selectedIndices)"
  }
}
