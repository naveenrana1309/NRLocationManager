

# NRLocationManager

[![Version](https://img.shields.io/cocoapods/v/NRLocationManager.svg?style=flat)](http://cocoapods.org/pods/NRLocationManager)
[![License](https://img.shields.io/cocoapods/l/NRLocationManager.svg?style=flat)](http://cocoapods.org/pods/NRLocationManager)
[![Platform](https://img.shields.io/cocoapods/p/NRLocationManager.svg?style=flat)](http://cocoapods.org/pods/NRLocationManager)
![ScreenShot](https://cdn.rawgit.com/naveenrana1309/NRLocationManager/master/Example/sample.png "Screeshot")



## Introduction

NRLocationManager: This class is used to provide a location updates via completion handler. Some of the main features of this library  are:
1) One time Location
2) Continous Location
3) Significant Location
4) Check System location is on/off

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
Xcode 9+ , Swift 4 , iOS 9 and above


## Plist Keys & Background Mode
Please make sure you have the below keys in your plist file before using the location services.

```
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>Description</string>

<key>NSLocationAlwaysUsageDescription</key>
<string>Will you allow this app to always know your location?</string>

<key>NSLocationWhenInUseUsageDescription</key>
<string>Do you allow this app to know your current location?</string>

Also enable background mode for location :
UIBackgroundModes -> Location updates
```

## Installation

NRLocationManager is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "NRLocationManager"
```



## Usage

# One Time Location
```
@IBAction func oneTimeLocationButtonPressed() {
updateLabel(string: "One Time Location ...")
NRLocationManger.shared.fetchLocation(locationType: .onetime) { (location, error) in
if error != nil {

} }
}

```

# Continuos Location

```
@IBAction func oneTimeLocationButtonPressed() {
updateLabel(string: "One Time Location ...")
NRLocationManger.shared.fetchLocation(locationType: .continous) { (location, error) in
if error != nil {

}}
}


```
# Significant Location

```
@IBAction func oneTimeLocationButtonPressed() {
updateLabel(string: "One Time Location ...")
NRLocationManger.shared.fetchLocation(locationType: .significant) { (location, error) in
if error != nil {

}}
}

```


## Contributing

Contributions are always welcome! (:

1. Fork it ( http://github.com/naveenrana1309/NRLocationManager/fork )
2. Create your feature branch ('git checkout -b my-new-feature')
3. Commit your changes ('git commit -am 'Add some feature')
4. Push to the branch ('git push origin my-new-feature')
5. Create new Pull Request

## Compatibility

Xcode 9+ , Swift 4 , iOS 10 and above

## Author

Naveen Rana. [See Profile](https://www.linkedin.com/in/naveen-rana-9a371a40)

Email:
naveenrana1309@gmail.com.

Check out [Facebook Profile](https://www.facebook.com/naveen.rana.146) for detail.

## License

NRLocationManager is available under the MIT license. See the LICENSE file for more info.

