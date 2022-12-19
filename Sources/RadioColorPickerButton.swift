//
//  ColorPickerButton.swift
//  RadioColorPicker
//
//  Created by Wallaby on 12/19/2022.
//  Copyright (c) 2022 Wallaby. All rights reserved.
//

import UIKit

public protocol RadioColorPickerButtonDelegate {
  func didChangeSelectedState(isSelected: Bool)
}

public class RadioColorPickerButton: UIControl {
  
  // MARK: - Properties
  
  public var delegate: RadioColorPickerButtonDelegate?
  private var oldFrame: CGRect = .zero
  
  
  // MARK: - UI
  
  private let innerCircleView = UIView()
  private var innerCircleTopConstraint: NSLayoutConstraint!
  private var innerCircleLeadingConstraint: NSLayoutConstraint!
  private var innerCircleTrailingConstraint: NSLayoutConstraint!
  private var innerCircleBottomConstraint: NSLayoutConstraint!
  private lazy var outerStrokeView = UIView()
  public var borderSpacing: CGFloat = 2 {
    didSet {
      updateView()
    }
  }
  public var borderWidth: CGFloat = 1.5 {
    didSet {
      outerStrokeView.layer.borderWidth = oldValue
      updateView()
    }
  }
  public var color: UIColor = .systemBlue {
    didSet {
      outerStrokeView.layer.borderColor = oldValue.cgColor
      innerCircleView.backgroundColor = oldValue
    }
  }
  private var totalSpacing: CGFloat {
    return borderWidth + borderSpacing
  }
  public var animationDuration: CGFloat = 0.4
  public var animationDelay: CGFloat = 0
  public var springDamping: CGFloat = 0.6
  public var initialSpringVelocity: CGFloat = 0.8
  
  
  // MARK: - Initializers
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  convenience init(initialSelectedState: Bool) {
    self.init(frame: .zero)
    initialSelectedState ? setSelected() : setDeselected()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }
  
  
  // MARK: - LifeCycles
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    if oldFrame != frame {
      oldFrame = frame
      updateView()
    }
  }
  
 
  // MARK: - Setups
  
  private func setup() {
    setupView()
  }
  
  private func setupView() {
    setupOuterStrokeView()
    setupInnerCircleView()
    setupGesture()
  }
  
  private func setupOuterStrokeView() {
    addSubview(outerStrokeView)
    outerStrokeView.translatesAutoresizingMaskIntoConstraints = false
    outerStrokeView.layer.borderWidth = borderWidth
    NSLayoutConstraint.activate([
      outerStrokeView.topAnchor.constraint(equalTo: self.topAnchor),
      outerStrokeView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      outerStrokeView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      outerStrokeView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
    ])
    outerStrokeView.layer.borderWidth = borderWidth
    outerStrokeView.layer.borderColor = color.cgColor
    outerStrokeView.backgroundColor = .clear
    outerStrokeView.isUserInteractionEnabled = false
    DispatchQueue.main.async {
      self.outerStrokeView.layer.cornerRadius = self.outerStrokeView.frame.width / 2
    }
  }
  
  private func setupInnerCircleView() {
    addSubview(innerCircleView)
    innerCircleView.translatesAutoresizingMaskIntoConstraints = false
    innerCircleTopConstraint = innerCircleView.topAnchor
      .constraint(equalTo: self.topAnchor)
    innerCircleLeadingConstraint = innerCircleView.leadingAnchor
      .constraint(equalTo: self.leadingAnchor)
    innerCircleTrailingConstraint = innerCircleView.trailingAnchor
      .constraint(equalTo: self.trailingAnchor)
    innerCircleBottomConstraint = innerCircleView.bottomAnchor
      .constraint(equalTo: self.bottomAnchor)
    NSLayoutConstraint.activate([
      innerCircleTopConstraint,
      innerCircleLeadingConstraint,
      innerCircleTrailingConstraint,
      innerCircleBottomConstraint
    ])
    innerCircleView.backgroundColor = color
    innerCircleView.isUserInteractionEnabled = false
    innerCircleView.layer.cornerRadius = self.innerCircleView.frame.width / 2
  }
  
  private func setupGesture() {
    self.addTarget(self, action: #selector(didTapColorPickerButton), for: .touchUpInside)
  }
  
  
  // MARK: - Methods
  
  public func setSelected() {
    isSelected = true
    playSelectedAnimation()
    delegate?.didChangeSelectedState(isSelected: true)
  }
  
  public func setDeselected() {
    isSelected = false
    playDeselectedAnimation()
    delegate?.didChangeSelectedState(isSelected: false)
  }
  
  private func playSelectedAnimation() {
    setInnerCircleSpacing(common: totalSpacing)
    UIView.animate(
      withDuration: animationDuration,
      delay: animationDelay,
      usingSpringWithDamping: springDamping,
      initialSpringVelocity: initialSpringVelocity) {
        self.outerStrokeView.layer.borderWidth = self.borderWidth
        self.innerCircleView.layer.cornerRadius = (self.outerStrokeView.frame.width - self.totalSpacing * 2) / 2
        self.layoutIfNeeded()
      }
  }
  
  private func playDeselectedAnimation() {
    setInnerCircleSpacing(common: 0)
    UIView.animate(
      withDuration: animationDuration,
      delay: animationDelay,
      usingSpringWithDamping: springDamping,
      initialSpringVelocity: initialSpringVelocity) {
        self.outerStrokeView.layer.borderWidth = 0
        self.innerCircleView.layer.cornerRadius = self.outerStrokeView.frame.width / 2
        self.layoutIfNeeded()
      }
  }
  
  private func setInnerCircleSpacing(common: CGFloat) {
    innerCircleTopConstraint.constant = common
    innerCircleLeadingConstraint.constant = common
    innerCircleTrailingConstraint.constant = -common
    innerCircleBottomConstraint.constant = -common
  }
  
  private func updateView() {
    if isSelected { setInnerCircleSpacing(common: borderSpacing + borderWidth) }
    outerStrokeView.layer.cornerRadius = outerStrokeView.frame.width / 2
    innerCircleView.layer.cornerRadius = innerCircleView.frame.width / 2
  }
  
  @objc
  private func didTapColorPickerButton(_ sender: UIControl) {
    isSelected ? setDeselected() : setSelected()
  }
}
