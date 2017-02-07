//
//  CSVExport.swift
//  SwiftCSVExport
//
//  Created by Vignesh on 07/02/17.
//  Copyright © 2017 vigneshuvi. All rights reserved.
//

import Foundation

//MARK: -  Extension for String to find length
extension String {
    var length: Int {
        return self.characters.count
    }
}

//MARK: -  CSVExport Class
open class CSVExport {
    
    ///The directory in which the cvs files will be written
    open var directory = CSVExport.defaultDirectory();
    
    //The name of the csv files.
    open var fileName = "csvfile";
    
    
    ///export singleton
    open class var export: CSVExport {
        
        struct Static {
            static let instance: CSVExport = CSVExport()
        }
        return Static.instance
    }
    
    ///write content to the current csv file.
    open func getFilePath() -> String{
        let path = "\(directory)/\(csvFileName())"
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: path) {
            return "";
        }
        return path;
    }

    
    ///write content to the current csv file.
    open func write(text: String) {
        let path = "\(directory)/\(csvFileName())"
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: path) {
            do {
                try "".write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
            } catch _ {
            }
        }
        if let fileHandle = FileHandle(forWritingAtPath: path) {
            let writeText = "\(text)\n"
            fileHandle.seekToEndOfFile()
            fileHandle.write(writeText.data(using: String.Encoding.utf8)!)
            fileHandle.closeFile()
            print(writeText, terminator: "")
            
        }
    }
    
    ///do the checks and cleanup
    open func cleanup() {
        let path = "\(directory)/\(csvFileName())"
        let size = fileSize(path)
        if size > 0 {
            //delete the oldest file
            let deletePath = "\(directory)/\(csvFileName())"
            let fileManager = FileManager.default
            do {
                try fileManager.removeItem(atPath: deletePath)
            } catch _ {
            }
        }
    }
    
    ///check the size of a file
    func fileSize(_ path: String) -> UInt64 {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: path) {
            let attrs: NSDictionary? = try! fileManager.attributesOfItem(atPath: path) as NSDictionary?
            if let dict = attrs {
                return dict.fileSize()
            }
        }
        return 0
    }
    
    
    ///gets the CSV name
    func csvFileName() -> String {
        return "\(fileName).csv"
    }
    
    ///get the default CSV directory
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

///a free function to make export the CSV file from file name, fields and values
public func exportCSV(_ filename:String, fields: NSArray, values: NSArray) -> String{
    
    if filename.length > 0 {
        CSVExport.export.fileName = filename;
    }
    CSVExport.export.cleanup();
    if fields.count > 0 && values.count > 0 {
        let  result:String = fields.componentsJoined(by: ",");
        CSVExport.export.write( text: result)
        for dict in values {
            let values = (dict as! NSDictionary).allValues as NSArray;
            let  result:String = values.componentsJoined(by: ",");
            CSVExport.export.write( text: result)
        }
    }
    return CSVExport.export.getFilePath();
}
