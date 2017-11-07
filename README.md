[![Language Swift 3](https://img.shields.io/badge/Language-Swift%203-orange.svg)](https://developer.apple.com/swift)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

# SwiftCSVExport
Simple way to export csv file with rich feature framework and written in Swift. It supports both Objective-C and Swift projects.

## Features

- Able to give CSV file name.
- Able to set CSV headers using fields.
- Able to convert JSON string into CSV.
- Able to Read the CSV file and convert to NSDictionary.
- Support CocoaPods, mac OS and Vapor framework(Swift Package Manager).
- Able to encoding CSV based on String.Encoding Type(utf8, ascii, unicode, utf16, etc) Refer: String.Encoding.
- Able to view the exported CSV documents in iOS Files app by enabling the configuration in your project.


##iOS/MacOS import headers

First thing is to import the framework. See the Installation instructions on how to add the framework to your project.

```swift

//iOS - Objective-C
@import SwiftCSVExport;

//iOS - Swift
import SwiftCSVExport

//macOS
import SwiftCSVExportOSX

```

## Configuration
- Able to view CSV exported CSV documents in iOS Files app.


```swift

Bundle display name - "APPLICATION NAME"
Application requires iPhone environment - YES
Supports opening documents in place - YES
Application supports iTunes file sharing - YES

```



## Examples:

### Example 1 - Objective-C

```swift

// First User Object
NSMutableDictionary *user1 = [NSMutableDictionary new];
[user1 setValue:@"vignesh" forKey:@"name" ];
[user1 setValue:@"vigneshuvi@gmail.com" forKey: @"email"];


// Secound User Object
NSMutableDictionary *user2 = [NSMutableDictionary new];
[user2 setValue:@"vinoth" forKey:@"name" ];
[user2 setValue:@"vigneshuvi@gmail.com" forKey: @"email"];


// CSV fields Array
NSMutableArray *fields = [NSMutableArray new];
[fields addObject:@"name"];
[fields addObject:@"email"];

// CSV rows Array
NSMutableArray *data = [NSMutableArray new];
[data addObject:user1];
[data addObject:user2];


NSString *userpath = [[CSVExport export] exportCSV:@"userlist1" fields:fields values:data];
NSLog(@"%@",userpath);

NSString *namepath =   [[CSVExport export] exportCSV:@"userlist1" fields:@[@"name", @"email"] values:data];
NSLog(@"%@",namepath);


// Able to convert JSON string into CSV.
NSString *string  = @"[{\"name\":\"vignesh\",\"email\":\"vigneshuvi@gmail.com\"},{\"name\":\"vinoth\",\"email\":\"vinoth@gmail.com\"}]";
NSString *filePath   = [[CSVExport export] exportCSVString:@"userlist1"fields:fields values:string];

NSLog(@"%@",filePath);

```

### Example 2 - Swift

```swift

// First User Object
let user1:NSMutableDictionary = NSMutableDictionary()
user1.setObject("vignesh", forKey: "name" as NSCopying);
user1.setObject("vigneshuvi@gmail.com", forKey: "email" as NSCopying);

// Secound User Object
let user2:NSMutableDictionary = NSMutableDictionary()
user2.setObject("vinoth", forKey: "name" as NSCopying);
user2.setObject("vinoth@gmail.com", forKey: "email" as NSCopying);

// Add fields into columns of CSV headers
let fields:NSMutableArray = NSMutableArray()
fields.add("name");
fields.add("email");

// Add dictionary into rows of CSV Array
let data:NSMutableArray  = NSMutableArray()
data.add(user1);
data.add(user2);

let filePath:String = SwiftCSVExport.exportCSV("userlist",fields: fields,values: data);
print(filePath)

```

### Example 3 - Swift
```swift


// First User Object
let user1:NSMutableDictionary = NSMutableDictionary()
user1.setObject("vignesh", forKey: "name" as NSCopying);
user1.setObject("vigneshuvi@gmail.com", forKey: "email" as NSCopying);

// Secound User Object
let user2:NSMutableDictionary = NSMutableDictionary()
user2.setObject("vinoth", forKey: "name" as NSCopying);
user2.setObject("vinoth@gmail.com", forKey: "email" as NSCopying);

// Add dictionary into rows of CSV Array
let data:NSMutableArray  = NSMutableArray()
data.add(user1);
data.add(user2);

let filePath:String = SwiftCSVExport.exportCSV("userlist",fields: ["name", "email"],values: data);
print(filePath)

```

### Example 4  - Swift
```swift


// Generate CSV file
let user1:NSMutableDictionary = NSMutableDictionary()
user1.setObject("vignesh", forKey: "name" as NSCopying);
user1.setObject("vigneshuvi@gmail.com", forKey: "email" as NSCopying);

let user2:NSMutableDictionary = NSMutableDictionary()
user2.setObject("vinoth", forKey: "name" as NSCopying);
user2.setObject("vinoth@gmail.com", forKey: "email" as NSCopying);

let data:NSMutableArray  = NSMutableArray()
data.add(user1);
data.add(user2);

let filePath:String = SwiftCSVExport.exportCSV("userlist",fields: ["name", "email"],values: data);
print(filePath)

```

### Example 5  - Swift

```swift

// Able to convert JSON string into CSV.
let string = "[{\"name\":\"vignesh\",\"email\":\"vigneshuvi@gmail.com\"},{\"name\":\"vinoth\",\"email\":\"vinoth@gmail.com\"}]";
let filePath:String = exportCSV("userlist", fields:["name","email"], values:string);
print(filePath)

// Read File
let fileDetails = readCSV(filePath);

// Use 'SwiftLoggly' pod framework to print the Dictionary
if fileDetails.allKeys.count > 0 {
    loggly(LogType.Info, dictionary: fileDetails)
}


```

### Write Output:

```swift

Output: userlist.csv

name,email
vignesh,vigneshuvi@gmail.com
vinoth,vinoth@gmail.com

```

### Example 6  - Swift

```swift

// Read File
let fileDetails = readCSV(filePath);

// Use 'SwiftLoggly' pod framework to print the Dictionary
if fileDetails.allKeys.count > 0 {
    loggly(LogType.Info, dictionary: fileDetails)
}


```

### Read Output:

```swift

[💙 Info -  Feb 7, 2017, 4:19:23 PM]: {
  "rows" : [
    {
      "name" : "vignesh",
      "email" : "vigneshuvi@gmail.com"
    },
    {
      "name" : "vinoth",
      "email" : "vinoth@gmail.com"
    }
  ],
  "name" : "userlist.csv",
  "fields" : [
    "name",
    "email"
  ]
}


```


That will create a CSV file in the proper directory on both OS X and iOS.

OS X CSV files will be created in the OS X Exports directory (found under: /Library/Exports). The iOS CSV files will be created in your apps document directory under a folder called Exports.

## Configuration

There are a few configurable options in SwiftCSVExport.

```swift

//Set the name of the csv file
CSVExport.export.fileName = "Sample" //default is "csvfile"

//Set the directory in which the csv files will be written
CSVExport.export.directory = "/Library/XXX-folder-name-XXX" //default is the standard exporting directory for each platform.

```

## Installation

### CocoaPods

Check out [Get Started](http://cocoapods.org/) tab on [cocoapods.org](http://cocoapods.org/).

To use SwiftCSVExport in your project add the following 'Podfile' to your project

	  source 'https://github.com/CocoaPods/Specs.git'
	  platform :ios, '8.0'
	  use_frameworks!

	  pod 'SwiftCSVExport'

Then run:

    pod install || pod update

### Carthage


To use SwiftCSVExport in your project create/update 'Cartfile.private' file into your project

    // Require version 1.x
    
    github "vigneshuvi/SwiftCSVExport"

Then run:

    carthage update

### Swift Package Manager for Vapor

You need to add to dependencies in your 'Package.swift' and fetch Swift module using terminal comment.

// Vapor

dependencies: [
        .Package(url: "https://github.com/vigneshuvi/SwiftCSVExport.git", majorVersion: 1, minor: 0)
        ],

Then run:

    vapor build || vapor xcode


// Importing header

import SwiftCSVExport


## License

SwiftCSVExport is licensed under the MIT License.

## Contact

### Vignesh Kumar
* http://vigneshuvi.github.io