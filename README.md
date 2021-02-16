# TTSnailPageControl

![](https://img.shields.io/badge/Swift-5.0-green.svg?style=flat)
[![SPM compatible](https://img.shields.io/badge/SPM-compatible-4BC51D.svg?style=flat)](https://swift.org/package-manager/)
[![License: MIT](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](https://github.com/s4cha/Stevia/blob/master/LICENSE)
[![Twitter](https://img.shields.io/badge/Twitter-@Tapptitude-blue.svg?style=flat)](http://twitter.com/Tapptitude)

## About

Just another cool aniamted page control.

![](Resources/demo.gif)

## Requirements

- iOS 11.0+
- Xcode 11.0+

## Installation

#### Swift Package Manager

`Xcode` > `File` > `Swift Packages` > `Add Package Dependency...` > `Paste` `https://github.com/tapptitude/TTSnailPageControl`

#### Manually

Add the contents of TTSnailPageControl/Sources/TTSnailPageControl folder to your project.

## Usage

1. Create a `TTSnailPageControl` instance either from code or using the interface builder. 

2. Set the `scrollView` property

```swift
pageControl.scrollView = scrollView
```

3. Configure the control

```swift
pageControl.configuration.itemsCount = 4
pageControl.configuration.itemSize = CGSize(width: 20, height: 10)
pageControl.configuration.spacing = 10.0
pageControl.configuration.layerConfiguration { (layer, index) in
        layer.backgroundColor = UIColor(named: "Unselected")?.cgColor
        layer.cornerRadius = 5
}
pageControl.configuration.selectionLayerConfiguration { (layer) in
        layer.backgroundColor = UIColor(named: "Selected")?.cgColor
        layer.cornerRadius = 5
}
```
## Contribution

Feel free to Fork, submit Pull Requests or send us your feedback and suggestions!


## License

TTSnailPageControl is available under the MIT license. See the LICENSE file for more info.
