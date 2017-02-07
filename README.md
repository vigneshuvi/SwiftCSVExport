# SwiftCSVExport
Simple way to export csv file with rich feature framework in Swift.

## Features

- Able to give CSV file name.
- Able to set CSV headers using fields.

First thing is to import the framework. See the Installation instructions on how to add the framework to your project.

```swift
//iOS
import SwiftCSVExport

//macOS
import SwiftCSVExportOSX

```


## Example


```swift


// Generate CSV file
let user1:NSMutableDictionary = NSMutableDictionary()
user1.setObject("vignesh", forKey: "name" as NSCopying);
user1.setObject("vigneshuvi@gmail.com", forKey: "email" as NSCopying);

let user2:NSMutableDictionary = NSMutableDictionary()
user2.setObject("vinoth", forKey: "name" as NSCopying);
user2.setObject("vinoth@gmail.com", forKey: "email" as NSCopying);

let fields:NSMutableArray = NSMutableArray()
fields.add("name");
fields.add("email");

let data:NSMutableArray  = NSMutableArray()
data.add(user1);
data.add(user2);

let path:String = SwiftCSVExport.exportCSV("userlist",fields: fields,values: data);
print(path)

// Just for fun!!
Output: userlist.csv

name,email
vignesh,vigneshuvi@gmail.com
vinoth,vinoth@gmail.com

```

That will create a log file in the proper directory on both OS X and iOS.

OS X log files will be created in the OS X log directory (found under: /Library/Logs). The iOS log files will be created in your apps document directory under a folder called Logs.

## Configuration

There are a few configurable options in SwiftLog.

```swift

//Set the name of the csv file
CSVExport.export.fileName = "Sample" //default is "csvfile"

//Set the directory in which the logs files will be written
CSVExport.export.directory = "/Library/XXX-folder-name-XXX" //default is the standard logging directory for each platform.

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


## License

SwiftCSVExport is licensed under the MIT License.

## Contact

### Vignesh Kumar
* http://vigneshuvi.github.io