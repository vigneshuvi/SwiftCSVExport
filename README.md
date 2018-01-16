[![CSV Swift](https://img.shields.io/badge/CSV-Swift-green.svg)](https://github.com/vigneshuvi/SwiftCSVExport)
[![Version](https://img.shields.io/cocoapods/v/SwiftCSVExport.svg)](https://github.com/vigneshuvi/SwiftCSVExport/releases)
[![Language Swift](https://img.shields.io/badge/Language-Swift%203-orange.svg)](https://developer.apple.com/swift)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

# SwiftCSVExport
**Swift CSV Export** is _lightweight & rich features framework_ and it _helpful to create, read and write CSV files_ in simple way. It supports both Objective-C and Swift projects.

## Features

- Able to give CSV file name, headers and rows using property keys.
- Able to convert JSON string into CSV.
- Able to Read the CSV file and convert to NSDictionary.
- Enable/Disable strict validation while write CSV file.
- Able to Read the CSV file and convert to CSV class(Object Oriented Approach).
- Support CocoaPods, mac OS and Vapor framework(Swift Package Manager).
- Able to encoding CSV based on String.Encoding Type(utf8, ascii, unicode, utf16, etc) Refer: String.Encoding.
- Able to view the exported CSV documents in iOS Files app by enabling the configuration in your project.
- Handled the punctuation(\n, \t, \t, and ,) characters in CSV file.


## iOS/MacOS import headers

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
- Add following keys in your project .plist file to view CSV exported CSV documents in iOS Files app.


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

### Example 2 - Swift - Object Oriented Approach

```swift

// First User Object
let user1:NSMutableDictionary = NSMutableDictionary()
user1.setObject(107, forKey: "userid" as NSCopying);
user1.setObject("vignesh", forKey: "name" as NSCopying);
user1.setObject("vigneshuvi@gmail.com", forKey: "email" as NSCopying);
user1.setObject(true, forKey:"isValidUser" as NSCopying)
user1.setObject("Hi 'Vignesh!' \nhow are you? \t Shall we meet tomorrow? \r Thanks ", forKey: "message" as NSCopying);
user1.setObject(571.05, forKey: "balance" as NSCopying);

// Secound User Object
let user2:NSMutableDictionary = NSMutableDictionary()
user2.setObject(108, forKey: "userid" as NSCopying);
user2.setObject("vinoth", forKey: "name" as NSCopying);
user2.setObject(false, forKey:"isValidUser" as NSCopying)
user2.setObject("vinoth@gmail.com", forKey: "email" as NSCopying);
user2.setObject("Hi 'Vinoth!', \nHow are you? \t Shall we meet tomorrow? \r Thanks ", forKey: "message" as NSCopying);
user2.setObject(567.50, forKey: "balance" as NSCopying);

// Add fields into columns of CSV headers
let header = ["userid", "name", "email", "message", "isValidUser","balance"]


// Add dictionary into rows of CSV Array
let data:NSMutableArray  = NSMutableArray()
data.add(user1);
data.add(user2);

// Create a object for write CSV
let writeCSVObj = CSV()
writeCSVObj.rows = data
writeCSVObj.delimiter = DividerType.comma.rawValue
writeCSVObj.fields = header as NSArray
writeCSVObj.name = "userlist"

// Write File using CSV class object
let result = exportCSV(writeCSVObj);
if result.isSuccess {
    guard let filePath =  result.value else {
        print("Export Error: \(String(describing: result.value))")
        return
    }
    self.testWithFilePath(filePath, rowCount: data.count, columnCount: header.count)
    print("File Path: \(filePath)")

    // Read File and convert as CSV class object
    let readCSVObj = readCSVObject(filePath);
     
    // Use 'SwiftLoggly' pod framework to print the Dictionary
    loggly(LogType.Info, text: readCSVObj.name)
} else {
    print("Export Error: \(String(describing: result.value))")
}




```

### Write & Read Output:

```swift

File Path: xxxxxx/xxxxxxx/Documents/Exports/userlist.csv

userid,name,email,message,isValidUser,balance
107,  "vignesh",  "vigneshuvi@gmail.com",  "Hi 'Vignesh!' \nhow are you? \t Shall we meet tomorrow? \r Thanks ",  1,  571.05
108,  "vinoth",  "vinoth@gmail.com",  "Hi 'Vinoth!', \nHow are you? \t Shall we meet tomorrow? \r Thanks ",  0,  567.5
109,  "John",  "John@gmail.com",  "Hi 'John!' \nHow are you? \t Shall we meet tomorrow? \r Thanks ",  1,  105.41


[💙 Info -  Jan 2, 2018, 4:52:28 PM]: userlist.csv


```

### Example 3  - Swift - Enable Strict Validation

```swift

// Enable Strict Validation
CSVExport.export.enableStrictValidation = true

// Able to convert JSON string into CSV.
let string = "[{\"name\":\"vignesh\",\"email\":\"vigneshuvi@gmail.com\"},{\"name\":\"vinoth\",\"email\":\"vinoth@gmail.com\"}]";

// Write File using CSV class object
let result1 = exportCSV("userlist", fields:["userid","name","email"], values:string);
XCTAssertEqual(false, result1.isSuccess)
if result1.isSuccess {
    guard let filePath =  result1.value else {
        print("Export Error: \(String(describing: result1.value))")
        return
    }
    print("File Path: \(filePath)")
    
} else {
    print("Export Error: \(String(describing: result1.value))")
}


```

### Write Output:

```swift

Export Error: Optional("Expected 3 columns, But Parsed 2 columns on row 1")

```

### Example 4  - Swift

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

[💙 Info -  Jan 2, 2018, 4:52:21 PM]: {
  "fields" : [
    "userid",
    "name",
    "email",
    "message",
    "isValidUser",
    "balance"
  ],
  "rows" : [
    {
      "email" : "\"vigneshuvi@gmail.com\"",
      "message" : "\"Hi 'Vignesh!' \\nhow are you? \\t Shall we meet tomorrow? \\r Thanks \"",
      "userid" : 107,
      "name" : "\"vignesh\"",
      "isValidUser" : 1,
      "balance" : 571.05
    },
    {
      "email" : "\"vinoth@gmail.com\"",
      "message" : "\"Hi 'Vinoth!', \\nHow are you? \\t Shall we meet tomorrow? \\r Thanks \"",
      "userid" : 108,
      "name" : "\"vinoth\"",
      "isValidUser" : 0,
      "balance" : 567.5
    },
    {
      "email" : "\"John@gmail.com\"",
      "message" : "\"Hi 'John!' \\nHow are you? \\t Shall we meet tomorrow? \\r Thanks \"",
      "userid" : 109,
      "name" : "\"John\"",
      "isValidUser" : 1,
      "balance" : 105.41
    }
  ],
  "name" : "userlist.csv",
  "divider" : ","
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

// Able to set strict validation while create a new CSV file.
CSVExport.export.enableStrictValidation = true


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
