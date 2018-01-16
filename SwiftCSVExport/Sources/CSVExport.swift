//
//  CSVExport.swift
//  SwiftCSVExport
//
//  Created by Vignesh on 07/02/17.
//  Copyright © 2017 vigneshuvi. All rights reserved.
//

import Foundation

// MARK: -  CSVExport - Class
@objc open class CSVExport:NSObject, CSVValidationProtocol {
    
    // MARK: - Variables
    /// The directory in which the cvs files will be written
    open var directory = CSVExport.defaultDirectory();
    
    /// The name of the csv files.
    open var fileName = "csvfile";
    
    /// The CSV encodeing format
    open var encodingType:String.Encoding = String.Encoding.utf8;
    
    /// The CSV cell separator
    open var divider: String?
    
    /// Enable Strict Validation
    open var enableStrictValidation: Bool = false
    
    /// The CSV File Manager
    let fileManager = FileManager.default
    
    /// Export singleton
    open class var export: CSVExport {
        
        struct Static {
            static let instance: CSVExport = CSVExport()
        }
        return Static.instance
    }
    
    // MARK: - Util - Functions
    
    /// Get Divider character
    func getDividerCharacter( ) -> String {
        return divider ?? ",";
    }
    
    /// A free function to convert from NSMutableDictionary to CSV object
    open func converToObject(_ fileDetails:NSMutableDictionary) -> CSV{
        let csvObj = CSV()
        if fileDetails.allKeys.count > 0 {
            let keys:[String] = fileDetails.allKeys as! [String]
            for key in keys  {
                switch key {
                case FieldName.fields:
                    let fieldValue = fileDetails.object(forKey: key) as! NSArray
                    csvObj.fields = fieldValue
                    break
                case FieldName.rows:
                    let fieldValue = fileDetails.object(forKey: key) as! NSArray
                    csvObj.rows = fieldValue
                    break
                case FieldName.name:
                    let fieldValue = fileDetails.object(forKey: key) as! String
                    csvObj.name = fieldValue
                    break
                case FieldName.divider:
                    let fieldValue = fileDetails.object(forKey: key) as! String
                    csvObj.delimiter = fieldValue
                    break
                default:
                    break
                }
            }
        }
        return csvObj;
    }
    
    func generateDict(_ fieldsArray: [String], valuesArray: [String] ) -> NSMutableDictionary {
        let rowsDictionary:NSMutableDictionary = NSMutableDictionary()
        for i in 0..<valuesArray.count {
            let key = fieldsArray[i];
            let value = valuesArray[i];
            
            if let lessPrecisePI = Float(value) {
                rowsDictionary.setObject(lessPrecisePI, forKey: key as NSCopying);
            } else if let morePrecisePI = Double(value) {
                rowsDictionary.setObject(morePrecisePI, forKey: key as NSCopying);
            } else {
                rowsDictionary.setObject(value, forKey: key as NSCopying);
            }
        }
        return rowsDictionary;
    }
    
    func splitUsingDelimiter(_ string: String, separatedBy: String) -> [Any] {
        if string.length > 0 {
            let t1 = string.components(separatedBy: separatedBy );
            return t1.filter{ !$0.isEmpty }
        }
        return [];
    }
    
    /// Write content to the current csv file.
    open func getFilePath() -> String{
        let path = "\(directory)/\(self.csvFileName())"
        if !fileManager.fileExists(atPath: path) {
            return "";
        }
        return path;
    }
    
    // MARK: - Functions
    
    /// A free function to make read the CSV file
    open func readCSV(_ filePath:String) -> NSMutableDictionary{
        return CSVExport.export.read(filepath: filePath);
    }
    
    
    /// A free function to make read the CSV file
    open func readCSVFromDefaultPath(_ fileName:String) -> NSMutableDictionary{
        return CSVExport.export.read(filename: fileName);
    }
    
    open func read(filename: String) -> NSMutableDictionary {
        let path = "\(directory)/\(filename)"
        return self.readFromPath(filePath:path);
    }
    
    open func read(filepath: String) -> NSMutableDictionary {
        return self.readFromPath(filePath:filepath);
    }
    
    open func exportCSV(_ filename:String, fields: NSArray, values: NSArray) -> Result<String>{
        var result:Result<String>? = nil
        guard fields.count > 0 || values.count > 0 else {
            return Result.invalid("Column and Row values are empty.")
        }
        
        guard filename.length > 0  else {
            return Result.invalid("Invalid file name.")
        }
        
        if filename.length > 0 {
            CSVExport.export.fileName = filename;
        }
        CSVExport.export.cleanup();
        
        let div = self.getDividerCharacter()
        let  fieldResult:String = fields.componentsJoined(by: div);
        CSVExport.export.write( text: fieldResult)
        var rowIndex = 1;
        for dict in values {
            let dictionary = (dict as! NSDictionary);
            if (enableStrictValidation) {
                let validationResult = validateRow(fields.count , rowColumnCount: dictionary.allKeys.count, row: rowIndex)
                if validationResult.isFailure {
                    result = validationResult
                    break
                }
            }
            var valueResult = ""
            for key in fields {
                if let value = dictionary.object(forKey: key) {
                    valueResult = valueResult.formatCSVRow(div, value: value)
                } else {
                    valueResult = valueResult.formatCSVRow(div, value: "")
                }
            }
            CSVExport.export.write( text: valueResult)
            rowIndex = rowIndex+1;
        }
        if result == nil {
             result = Result.valid(CSVExport.export.getFilePath())
        }
        return result!
        
    }
    
    /// A free function to make export the CSV file from file name, fields and values
    open  func exportCSVString(_ filename:String, fields: [String], values: String) -> Result<String>{
        // Convert String into NSArray of objects.
        guard let data = (values as NSString).data(using: CSVExport.export.encodingType.rawValue) else {
            return Result.invalid("Column and Row values are empty.")
        }
        do {
            let parsedObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSArray
            if parsedObject.count > 0
            {
                return CSVExport.export.exportCSV(filename, fields: fields as NSArray, values: parsedObject);
            }
        } catch  {
             print("error handling...\(error)")
             return Result.invalid("Invalid JSON string.")
        }
        return Result.invalid("Column and Row values are empty.")
    }
    
    // MARK: - File Manager - Util - Functions
    
    /// Write content to the current csv file.
    open func write(text: String) {
        let path = "\(directory)/\(self.csvFileName())"
        
        let updatedString = text.replaceEscapeCharacters()
        
        if !fileManager.fileExists(atPath: path) {
            do {
                try "".write(toFile: path, atomically: true, encoding: encodingType)
            } catch _ {
            }
        }
        if let fileHandle = FileHandle(forWritingAtPath: path) {
            let writeText = "\(updatedString)\n"
            fileHandle.seekToEndOfFile()
            fileHandle.write(writeText.data(using: encodingType)!)
            fileHandle.closeFile()
            print(writeText, terminator: "")
        }
    }
    
    /// Read content to the current csv file.
    open func readFromPath(filePath: String) -> NSMutableDictionary {
        let output:NSMutableDictionary = NSMutableDictionary()
        
        // Find the CSV file path is available
        if fileManager.fileExists(atPath: filePath) {
            do {
                // Generate the Local file path URL
                let localPathURL: URL = NSURL.fileURL(withPath: filePath);
                
                // Read the content from Local Path
                let csvText = try String(contentsOf: localPathURL, encoding: encodingType);
                
                // Check the csv count
                guard csvText.length > 0 else {
                    return output
                }
                
                // Split based on Newline delimiter
                let csvArray = self.splitUsingDelimiter(csvText, separatedBy: "\n") as! [String]
                if csvArray.count >= 2 {
                    var fieldsArray = [Any]();
                    var rowsArray = [Any]();
                    let div = self.getDividerCharacter()
                    for row in csvArray {
                        // Get the CSV headers
                        if(row.contains(csvArray[0])) {
                            fieldsArray = self.splitUsingDelimiter(row, separatedBy: div);
                        } else {
                            // Get the CSV values
                            let valuesArray = self.splitUsingDelimiter(row, separatedBy: "\(div)  ");
                            if valuesArray.count == fieldsArray.count  && valuesArray.count > 0 {
                                let rowJson:NSMutableDictionary = self.generateDict(fieldsArray as! [String], valuesArray: valuesArray as! [String])
                                if rowJson.allKeys.count > 0 && valuesArray.count == rowJson.allKeys.count && rowJson.allKeys.count == fieldsArray.count {
                                    rowsArray.append(rowJson)
                                }
                            }
                        }
                    }
                    
                    // Set the CSV headers & Values and name in the dict.
                    if fieldsArray.count > 0 && rowsArray.count > 0 {
                        output.setObject(fieldsArray, forKey: FieldName.fields as NSCopying)
                        output.setObject(rowsArray, forKey: FieldName.rows as NSCopying)
                        output.setObject(localPathURL.lastPathComponent, forKey: FieldName.name as NSCopying)
                        output.setObject(self.getDividerCharacter(), forKey: FieldName.divider as NSCopying)
                    }
                }
            }
            catch {
                /* error handling here */
                print("Error while read csv: \(error)", terminator: "")
            }
        }
        return output;
    }
    
    
    
    /// Do the checks and cleanup
    open func cleanup() {
        let path = "\(directory)/\(self.csvFileName())"
        let size = self.fileSize(path)
        if size > 0 {
            //delete the oldest file
            let deletePath = "\(directory)/\(self.csvFileName())"
            do {
                try fileManager.removeItem(atPath: deletePath)
            } catch _ {
            }
        }
    }
    
    /// Check the size of a file
    open func fileSize(_ path: String) -> UInt64 {
        guard fileManager.fileExists(atPath: path) else {
            return 0
        }
        let dict: NSDictionary = try! fileManager.attributesOfItem(atPath: path) as NSDictionary
        if dict.count > 0 {
            return dict.fileSize()
        }
        return 0
    }
    
    
    /// Get the CSV name
    func csvFileName() -> String {
        return "\(fileName).csv"
    }
    
    /// Get the default CSV directory
    class func defaultDirectory() -> String {
        var path = ""
        let fileManager = FileManager.default
        #if os(iOS)
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            path = "\(paths[0])/Exports"
        #elseif os(OSX)
            let urls = fileManager.urls(for: .libraryDirectory, in: .userDomainMask)
            if let url = urls.last?.path {
                path = "\(url)/Exports"
            }
        #endif
        if !fileManager.fileExists(atPath: path) && path != ""  {
            do {
                try fileManager.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
            } catch _ {
            }
        }
        return path
    }
    
}



//MARK: -  Export public Methods

/// A free function to make export the CSV file from file name, fields and values
public func exportCSV(_ csvObj:CSV) -> Result<String> {
    CSVExport.export.divider =  csvObj.delimiter
    return CSVExport.export.exportCSV(csvObj.name, fields: csvObj.fields, values: csvObj.rows);
}

/// A free function to make export the CSV file from file name, fields and values
public func exportCSV(_ filename:String, fields: NSArray, values: NSArray) -> Result<String>{
    return CSVExport.export.exportCSV(filename, fields: fields, values: values);
}

/// A free function to make export the CSV file from file name, fields and values
public func exportCSV(_ filename:String, fields: [String], values: NSArray) -> Result<String>{
    return CSVExport.export.exportCSV(filename, fields: fields as NSArray, values: values);
}

/// A free function to make export the CSV file from file name, fields and values
public func exportCSV(_ filename:String, fields: [String], values: [[String:Any]]) -> Result<String>{
    // Convert [String:Any] to NSDictionary
    let data:NSMutableArray  = NSMutableArray()
    for dict in  values {
        let row:NSMutableDictionary = NSMutableDictionary()
        for i in 0 ..< fields.count {
            row.setValue((dict[fields[i]] != nil ? dict[fields[i]]  : ""), forKey: fields[i] );
        }
        data.add(row)
    }
    
    return CSVExport.export.exportCSV(filename, fields: fields as NSArray, values: data);
}

/// A free function to make export the CSV file from file name, fields and values
public func exportCSV(_ filename:String, fields: [String], values: String) -> Result<String>{
    return CSVExport.export.exportCSVString(filename, fields: (fields as NSArray) as! [String], values: values);
}

/// A free function to make read the CSV file
public func readCSV(_ filePath:String) -> NSMutableDictionary{
    return CSVExport.export.readCSV(filePath);
}

/// A free function to make read the CSV file
public func readCSVFromDefaultPath(_ fileName:String) -> NSMutableDictionary{
    return CSVExport.export.readCSVFromDefaultPath(fileName);
}

/// A free function to make read the CSV file
public func readCSVObject(_ filePath:String) -> CSV {
    let fileDetails = CSVExport.export.readCSV(filePath);
    return CSVExport.export.converToObject(fileDetails)
}

/// A free function to make read the CSV file
public func readCSVObjectFromDefaultPath(_ fileName:String) -> CSV {
    let fileDetails = CSVExport.export.readCSVFromDefaultPath(fileName);
    return CSVExport.export.converToObject(fileDetails)
}

/// List Properties With Values. Helpful to convert Object into NSMutableDictionary.
public func listPropertiesWithValues(_ object: AnyObject?, reflect: Mirror? = nil) -> NSMutableDictionary {
    let mirror = reflect ?? Mirror(reflecting: object!)
    
    let dictionary:NSMutableDictionary = NSMutableDictionary()
    for (_, attr) in mirror.children.enumerated() {
        if let property_name = attr.label as String! {
            dictionary.setObject(attr.value, forKey: property_name as NSCopying);
        }
    }
    return dictionary;
}

