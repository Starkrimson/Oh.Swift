# Oh.Swift

[![Version](https://img.shields.io/cocoapods/v/Oh.Swift.svg?style=flat)](https://cocoapods.org/pods/Oh.Swift)
[![License](https://img.shields.io/cocoapods/l/Oh.Swift.svg?style=flat)](https://cocoapods.org/pods/Oh.Swift)
[![Platform](https://img.shields.io/cocoapods/p/Oh.Swift.svg?style=flat)](https://cocoapods.org/pods/Oh.Swift)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

### Extension 

```Swift
// UIColor
view.backgroundColor = .oh.hex(0xFFFFFF)
view.backgroundColor = .oh.random


// UITableView
tableView.oh.register(UITableViewCell.self)
// ...
let cell = tableView.oh.dequeue(UITableViewCell.self)
```

### Property Wrapper

```swift
// UserDefaultsWrapper 

import OhSwift

@UserDefaultsWrapper("oh.swift.toggle", defaultValue: true)
var toggle: Bool!

// UserDefaults.standard.bool(forKey: "oh.swift.toggle")
"toggle \(toggle!)"

// UserDefaults.standard.set(false, forKey: "oh.swift.toggle")
// UserDefaults.standard.synchronize()
toggle = false
```

```swift
// CodableDefaultWrapper


struct Model: Codable {
    @Default<String> var text: String
    @Default<Int> var integer: Int
    @Default<Double> var decimal: Double
    @Default.True var flag: Bool
}

// ...

let jsonString = """
                 {
                    "text1": "hello world!",
                    "integer": 99,
                    "decimal": 66
                 }
                 """
do {
    let model = try JSONDecoder().decode(Model.self, from: jsonString.data(using: .utf8)!)
    print(model) // text = "", integer = 99, decimal = 66.0, flag = true
} catch {
    print(error.localizedDescription)
}
```

[More...](https://anicon.notion.site/Oh-Swift-Example-8edc323562694825b2e8966cf70778cb)

## Installation

Oh.Swift is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Oh.Swift'
```

## Author

Starkrimson, starkrimson@icloud.com

## License

Oh.Swift is available under the MIT license. See the LICENSE file for more info.
