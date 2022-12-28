# RadioColorPicker

[![CI Status](https://img.shields.io/travis/SunneyG/RadioColorPicker.svg?style=flat)](https://travis-ci.org/SunneyG/RadioColorPicker)
[![Version](https://img.shields.io/cocoapods/v/RadioColorPicker.svg?style=flat)](https://cocoapods.org/pods/RadioColorPicker)
[![License](https://img.shields.io/cocoapods/l/RadioColorPicker.svg?style=flat)](https://cocoapods.org/pods/RadioColorPicker)
[![Platform](https://img.shields.io/cocoapods/p/RadioColorPicker.svg?style=flat)](https://cocoapods.org/pods/RadioColorPicker)
![SwiftPM](https://img.shields.io/badge/SPM-supported-DE5C43.svg?style=flat)

## Example

<img src="https://user-images.githubusercontent.com/63496607/209635046-3a2dfe9b-32bb-4523-9d19-ef49cfab4664.gif"></img>


To run the example project, clone the repo, and run `pod install` from the Example directory first.

</br>

## Requirements

iOS 13.0+

</br>

## Installation
RadioColorPicker is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'RadioColorPicker'
```

</br>

## Rx Extension
If you are using rxswift, you can use delegate as Observable with the code below.
```swift

import UIKit
import RadioColorPicker

import RxSwift
import RxCocoa

class RxRadioColorPickerDelegateProxy: DelegateProxy<RadioColorPicker, RadioColorPickerDelegate>, DelegateProxyType, RadioColorPickerDelegate {
  static func registerKnownImplementations() {
    self.register { radioColorPicker -> RxRadioColorPickerDelegateProxy in
      RxRadioColorPickerDelegateProxy(parentObject: radioColorPicker, delegateProxy: self)
    }
  }
  
  static func currentDelegate(for object: RadioColorPicker) -> RadioColorPickerDelegate? {
    return object.delegate
  }
  
  static func setCurrentDelegate(_ delegate: RadioColorPickerDelegate?, to object: RadioColorPicker) {
    object.delegate = delegate
  }
}

extension Reactive where Base: RadioColorPicker {
  var delegate: RxRadioColorPickerDelegateProxy {
    return RxRadioColorPickerDelegateProxy.proxy(for: self.base)
  }
  
  var selectedIndex: Observable<Int?> {
    return delegate.sentMessage(#selector(RadioColorPickerDelegate.didItemSelected(index:color:)))
      .map { value in
        if let selectedIndex = value.first as? Int {
          return selectedIndex
        }
        return nil
      }
  }
  
  var selectedColor: Observable<UIColor?> {
    return delegate.sentMessage(#selector(RadioColorPickerDelegate.didItemSelected(index:color:)))
      .map { value in
        if let selectedColor = value[1] as? UIColor {
          return selectedColor
        }
        return nil
      }
  }
}

```

</br>

## Author

Wallaby, avocado34.131@gmail.com

</br>

## License

RadioColorPicker is available under the MIT license. See the LICENSE file for more info.
