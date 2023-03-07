//
//  RadioColorPicker.swift
//  RadioColorPicker
//
//  Created by Wallaby on 12/19/2022.
//  Copyright (c) 2022 Wallaby. All rights reserved.
//

import UIKit

public enum RadioColorPickerAlignment {
  case leading
  case center
  case trailing
}

public enum RadioColorPickerScrollDirection {
  case vertical
  case horizontal
}

@objc public protocol RadioColorPickerDelegate {
  @objc optional func didItemSelected(index: Int, color: UIColor)
  @objc optional func didItemDeselected(index: Int, color: UIColor)
}

@IBDesignable
open class RadioColorPicker: UIView {
  
  // MARK: - Constants
  
  struct Metric {
    static let defaultPickerSize: CGFloat = 36
    static let defaultVerticalSpacing: CGFloat = 12
    static let defaultHorizontalSpacing: CGFloat = 8
  }
  
  
  // MARK: - Properties
  
  open var delegate: RadioColorPickerDelegate?
  open var colors = [UIColor]()
  open var selectedColors: [UIColor] {
    var selectedColors = [UIColor]()
    for selectedIndexPath in collectionView.indexPathsForSelectedItems ?? [] {
      selectedColors.append(colors[selectedIndexPath.row])
    }
    return selectedColors
  }
  open var selectedIndices: [Int] {
    var indices = [Int]()
    for selectedIndexPath in collectionView.indexPathsForSelectedItems ?? [] {
      indices.append(selectedIndexPath.row)
    }
    return indices
  }
  open var pickerSize = Metric.defaultPickerSize {
    didSet {
      if oldValue == pickerSize { return }
      updateLayout()
    }
  }
  open var verticalSpacing = Metric.defaultVerticalSpacing {
    didSet {
      if oldValue == verticalSpacing { return }
      updateLayout()
    }
  }
  open var horizontalSpacing = Metric.defaultHorizontalSpacing {
    didSet {
      if oldValue == horizontalSpacing { return }
      updateLayout()
    }
  }
  open var scrollDirection: RadioColorPickerScrollDirection = .horizontal {
    didSet {
      if oldValue == scrollDirection { return }
      updateLayout()
    }
  }
  open var alignment: RadioColorPickerAlignment = .leading {
    didSet {
      if oldValue == alignment { return }
      updateLayout()
    }
  }
  open var borderSpacing = RadioColorPickerCollectionViewCell.Metric.defaultBorderSpacing {
    didSet { reloadDataSelected() }
  }
  open var borderWidth = RadioColorPickerCollectionViewCell.Metric.defaultBorderWidth {
    didSet { reloadDataSelected() }
  }
  open var contentInset: NSDirectionalEdgeInsets = .init() {
    didSet {
      if oldValue == contentInset { return }
      updateLayout()
    }
  }
  open var allowsMultipleSelection: Bool = false {
    didSet {
      collectionView.allowsMultipleSelection = allowsMultipleSelection
    }
  }
  open override var intrinsicContentSize: CGSize {
    let width = CGFloat(colors.count) * pickerSize + contentInset.leading + contentInset.trailing + CGFloat(colors.count) * horizontalSpacing
    let height = pickerSize + contentInset.top + contentInset.bottom
    return .init(width: width, height: height)
  }
  
  
  // MARK: - UI
  
  private var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: collectionViewLayoutFactory())
  
  
  // MARK: - Initializers
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  public convenience init(colors: [UIColor]) {
    self.init(frame: .zero)
    self.colors = colors
  }
  
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }
  
  private static func collectionViewLayoutFactory(
    pickerSize: CGFloat = Metric.defaultPickerSize,
    verticalSpacing: CGFloat = Metric.defaultVerticalSpacing,
    horizontalSpacing: CGFloat = Metric.defaultHorizontalSpacing,
    scrollDirection: RadioColorPickerScrollDirection = .horizontal,
    alignment: RadioColorPickerAlignment = .leading,
    contentInset: NSDirectionalEdgeInsets = .init()
  ) -> UICollectionViewCompositionalLayout {
    // Item
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .absolute(pickerSize),
      heightDimension: .absolute(pickerSize))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    // Group
    let widthDimension: NSCollectionLayoutDimension = scrollDirection == .vertical ?  .fractionalWidth(1) : .absolute(pickerSize)
    let groupSize = NSCollectionLayoutSize(
      widthDimension: widthDimension,
      heightDimension: .absolute(pickerSize))
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitems: [item])
    group.interItemSpacing = scrollDirection == .vertical ? .flexible(horizontalSpacing) : .fixed(horizontalSpacing)
    group.edgeSpacing = scrollDirection == .vertical ?
      .init(
        leading: .flexible(horizontalSpacing / 2),
        top: .fixed(0),
        trailing: .flexible(horizontalSpacing / 2),
        bottom: .fixed(0))
    :
      .init(
        leading: .fixed(horizontalSpacing / 2),
        top: .fixed(0),
        trailing: .fixed(horizontalSpacing / 2),
        bottom: .fixed(0))
    
    // Section
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = scrollDirection == .vertical ?  verticalSpacing : .zero
    section.contentInsets = contentInset
    section.orthogonalScrollingBehavior = scrollDirection == .vertical ? .none : .continuous
    
    // Layout
    let layout = UICollectionViewCompositionalLayout(section: section)
    return layout
  }
  
  
  // MARK: - Setups
  
  private func setup() {
    setupView()
    invalidateIntrinsicContentSize()
  }
  
  private func setupView() {
    setupCollectionView()
  }
  
  private func setupCollectionView() {
    addSubview(collectionView)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
    
    collectionView.register(
      RadioColorPickerCollectionViewCell.self,
      forCellWithReuseIdentifier: RadioColorPickerCollectionViewCell.identifier)
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.backgroundColor = .clear
    collectionView.alwaysBounceHorizontal = false
    collectionView.alwaysBounceVertical = false
    collectionView.allowsMultipleSelection = allowsMultipleSelection
  }
  
  
  // MARK: - Methods
  
  open func addColor(_ color: UIColor) {
    colors.append(color)
    updateLayout()
  }
  
  open func removeColor() {
    if colors.isEmpty { return }
    let indexPath = IndexPath(item: colors.count - 1, section: 0)
    collectionView.deselectItem(at: indexPath, animated: false)
    colors.removeLast()
    updateLayout()
  }
  
  open func removeColor(at index: Int) {
    if colors.count <= index || index < 0 { return }
    let indexPath = IndexPath(item: index, section: 0)
    collectionView.deselectItem(at: indexPath, animated: false)
    colors.remove(at: index)
    updateLayout()
  }
  
  open func setSelected(index: Int) {
    let indexPath = IndexPath(item: index, section: 0)
    switch scrollDirection {
    case .vertical:
      collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredVertically)
    case .horizontal:
      collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
  }
  
  private func updateLayout() {
    let newLayout = Self.collectionViewLayoutFactory(
      pickerSize: pickerSize,
      verticalSpacing: verticalSpacing,
      horizontalSpacing: horizontalSpacing,
      scrollDirection: scrollDirection,
      alignment: alignment,
      contentInset: contentInset)
    collectionView.collectionViewLayout = newLayout
    reloadDataSelected()
    collectionView.collectionViewLayout.invalidateLayout()
    invalidateIntrinsicContentSize()
  }
  
  private func reloadDataSelected() {
    let selectedIndexPaths = collectionView.indexPathsForSelectedItems ?? []
    collectionView.reloadData()
    
    for indexPath in selectedIndexPaths {
      collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
    }
  }
}


// MARK: - CollectionView Delegate, DataSources

extension RadioColorPicker: UICollectionViewDataSource, UICollectionViewDelegate {
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return colors.count
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: RadioColorPickerCollectionViewCell.identifier,
      for: indexPath) as? RadioColorPickerCollectionViewCell else {
      return UICollectionViewCell()
    }
    
    // Preserve selection state
    if let selectedIndexPaths = collectionView.indexPathsForSelectedItems {
      if selectedIndexPaths.contains(indexPath) {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
      }
    }
    
    cell.configure(
      color: colors[indexPath.row],
      borderSpacing: borderSpacing,
      borderWidth: borderWidth)
    return cell
  }
  
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let index = indexPath.row
    delegate?.didItemSelected?(index: index, color: colors[index])
  }
  
  public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    let index = indexPath.row
    delegate?.didItemDeselected?(index: index, color: colors[index])
  }
}
