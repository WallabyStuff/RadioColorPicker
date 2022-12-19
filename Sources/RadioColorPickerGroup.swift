//
//  RadioColorPickerGroup.swift
//  RadioColorPicker
//
//  Created by Wallaby on 12/19/2022.
//  Copyright (c) 2022 Wallaby. All rights reserved.
//

import UIKit

public protocol RadioColorPickerGroupDelegate {
  func didItemSelected(index: Int, color: UIColor)
}

public class RadioColorPickerGroup {
  
  // MARK: - Properties
  
  public var delegate: RadioColorPickerGroupDelegate?
  public var colors = [UIColor]()
  private var selectedIndex: Int?
  
  
  // MARK: - UI
  
  private var stackView: UIStackView = {
    let stackView = UIStackView()
    return stackView
  }()
  
  
  // MARK: - Initializers
  
  public init() {
    setup()
  }
  
  public init(colors: [UIColor]) {
    self.colors = colors
    setup()
  }
  
  // MARK: - Setups
  
  private func setup() {
    setupView()
  }
  
  private func setupView() {
    
  }
  
  
  // MARK: - Methods
  
  public func addColor(_ color: UIColor) {
    colors.append(color)
  }
  
  public func removeColor() {
    colors.removeLast()
  }
  
  public func removeColor(index: Int) {
    colors.remove(at: index)
  }
  
  public func setSelected(index: Int) {
    delegate?.didItemSelected(index: index, color: colors[index])
  }
  
  public var selectedColor: UIColor? {
    if let selectedIndex = self.selectedIndex {
      return colors[selectedIndex]
    }
    return nil
  }
}
