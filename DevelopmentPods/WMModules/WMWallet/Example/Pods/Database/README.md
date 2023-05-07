# Database
It is a protocol to easily handle database __read/write__ on top of Realm as singleton.

[![CI Status](http://img.shields.io/travis/matteocrippa/Database.svg?style=flat)](https://travis-ci.org/matteocrippa/Database)
[![Version](https://img.shields.io/cocoapods/v/Database.svg?style=flat)](http://cocoapods.org/pods/Database)
[![License](https://img.shields.io/cocoapods/l/Database.svg?style=flat)](http://cocoapods.org/pods/Database)
[![Platform](https://img.shields.io/cocoapods/p/Database.svg?style=flat)](http://cocoapods.org/pods/Database)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

Database is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Database"
```

## Usage

### Configuration

`DatabaseConfiguration` handles the database configuration, the database implementation has been made on top of `Databaseable` protocol.

In configuration you can set:

- name, it is not linked yet
- type, it supports `disk` or `memory` database
- debug, it supports different logging types

`DatabaseDebugVerbosity` supports:
- none, no message will be shown (Default)
- all, all messages will be shown
- error, only setting and error will be shown
- message, all messages will be shown

### Database
`Databaseable` protocol allows you to:

- `get` to get items of `Realm` type or an item using key
- `save` to save from `JSON`, `Realm` object or sequence
- `delete` to remove an object of `Realm` type


## Author

matteocrippa, @ghego20

## License

Database is available under the MIT license. See the LICENSE file for more info.
