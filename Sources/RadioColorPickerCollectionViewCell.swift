//
//  RadioColorPickerCollectionViewCell.swift
//  RadioColorPicker
//
//  Created by Wallaby on 2022/12/23.
//  Copyright (c) 2022 Wallaby. All rights reserved.
//

import UIKit

public class RadioColorPickerCollectionViewCell: UICollectionViewCell {
  
  // MARK: - Constants
  
  static let identifier = "RadioColorPickerCell"
  struct Metric {
    static let animationDuration: CGFloat = 0.4
    static let animationDelay: CGFloat = 0
    static let springDamping: CGFloat = 0.6
    static let initialSpringVelocity: CGFloat = 0.8
    static let defaultBorderSpacing: CGFloat = 2
    static let defaultBorderWidth: CGFloat = 1.5
  }
  
  
  // MARK: - Properties
  
  private var oldFrame: CGRect = .zero
  open override var isSelected: Bool {
    willSet {
      if isSelected == newValue { return }
      newValue ? setSelected(animation: true) : setDeselected(animation: true)
    }
  }
  private var animationDuration = Metric.animationDuration
  private var animationDelay = Metric.animationDelay
  private var springDamping = Metric.springDamping
  private var initialSpringVelocity = Metric.initialSpringVelocity
  private var borderSpacing = Metric.defaultBorderSpacing {
    willSet {
      updateView()
    }
  }
  private var borderWidth = Metric.defaultBorderWidth {
    willSet {
      outerStrokeView.layer.borderWidth = newValue
      updateView()
    }
  }
  private var color: UIColor = .systemBlue {
    willSet {
      outerStrokeView.layer.borderColor = newValue.cgColor
      innerCircleView.backgroundColor = newValue
    }
  }
  private var totalSpacing: CGFloat {
    return borderWidth + borderSpacing
  }
  
  
  // MARK: - UI
  
  private let innerCircleView = UIView()
  private var innerCircleTopConstraint: NSLayoutConstraint!
  private var innerCircleLeadingConstraint: NSLayoutConstraint!
  private var innerCircleTrailingConstraint: NSLayoutConstraint!
  private var innerCircleBottomConstraint: NSLayoutConstraint!
  private var outerStrokeView = UIView()
  
  
  // MARK: - Initializers
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    if oldFrame != frame {
      oldFrame = frame
      updateView()
    }
  }
  
  
  // MARK: - LifeCyle
  
  open override func prepareForReuse() {
    super.prepareForReuse()
    if isSelected {
      setSelected(animation: false)
    } else {
      setDeselected(animation: false)
    }
  }
  
  
  // MARK: - Setups
  
  private func setup() {
    setupView()
  }
  
  private func setupView() {
    clipsToBounds = false
    setupOuterStrokeView()
    setupInnerCircleView()
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
      .constraint(equalTo: topAnchor)
    innerCircleLeadingConstraint = innerCircleView.leadingAnchor
      .constraint(equalTo: leadingAnchor)
    innerCircleTrailingConstraint = innerCircleView.trailingAnchor
      .constraint(equalTo: trailingAnchor)
    innerCircleBottomConstraint = innerCircleView.bottomAnchor
      .constraint(equalTo: bottomAnchor)
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
  
  
  // MARK: - Methods
  
  public func configure(
    color: UIColor,
    borderSpacing: CGFloat,
    borderWidth: CGFloat) {
      self.color = color
      self.borderSpacing = borderSpacing
      self.borderWidth = borderWidth
    }
  
  private func setSelected(animation: Bool = true) {
    let duration = animation ? animationDuration : 0
    setInnerCircleSpacing(common: totalSpacing)
    UIView.animate(
      withDuration: duration,
      delay: animationDelay,
      usingSpringWithDamping: springDamping,
      initialSpringVelocity: initialSpringVelocity) {
        self.outerStrokeView.layer.borderWidth = self.borderWidth
        self.innerCircleView.layer.cornerRadius = (self.outerStrokeView.frame.width - self.totalSpacing * 2) / 2
        self.layoutIfNeeded()
      }
  }
  
  private func setDeselected(animation: Bool = true) {
    let duration = animation ? animationDuration : 0
    setInnerCircleSpacing(common: 0)
    UIView.animate(
      withDuration: duration,
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
}
