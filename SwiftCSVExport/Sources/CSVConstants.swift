//
//  CSVConstants.swift
//  SwiftCSVExport
//
//  Created by Vignesh on 12/01/18.
//  Copyright © 2018 vigneshuvi. All rights reserved.
//

import Foundation

//MARK: -  CSV output dictionay keys - Constants
public struct FieldName {
    public static let fields = "fields"
    public static let rows = "rows"
    public static let name = "name"
    public static let divider = "divider"
}

//MARK: -  Divider type - Enumeration
public enum DividerType: String {
    case comma = ","
    case semicolon = ";"
}

// MARK: -  CSV Class
@objc public class CSV:NSObject {
    open var fields:NSArray = []
    open var rows:NSArray = []
    open var name:String = ""
    open var delimiter:String = DividerType.comma.rawValue
}

// MARK: -  Extension for NSMutableDictionary
public extension NSMutableDictionary {
    
    public var hasData:Bool {
        return  self.allKeys.count > 0 && self.allValues.count > 0
    }
    
    public var fields: [Any] {
        guard let fields =  self.object(forKey:FieldName.fields) else {
            return []
        }
        return fields as! [Any];
    }
    
    public var rows: [Any] {
        guard let rows =  self.object(forKey:FieldName.rows)  else {
            return []
        }
        return rows as! [Any]
    }
    
    public var name: String {
        guard let name =  self.object(forKey:FieldName.name) else {
            return ""
        }
        return name as! String
    }
    
    public var delimiter: String {
        guard let delimiter =  self.object(forKey:FieldName.divider) else {
            return ""
        }
        return delimiter as! String
    }
}

// MARK: -  Extension for String
extension String {
    
    /// Get lines split by Newline delimiter.
    var lines: [String] {
        var result: [String] = []
        enumerateLines { line, _ in result.append(line) }
        return result
    }
    
    func split(regex pattern: String) -> [String] {
        
        guard let re = try? NSRegularExpression(pattern: pattern, options: [])
            else { return [] }
        
        let nsString = self as NSString // needed for range compatibility
        let stop = "<SomeStringThatYouDoNotExpectToOccurInSelf>"
        let modifiedString = re.stringByReplacingMatches(
            in: self,
            options: [],
            range: NSRange(location: 0, length: nsString.length),
            withTemplate: stop)
        return modifiedString.components(separatedBy: stop)
    }
    
    /// Getting the characters length
    var length: Int {
        return self.count
    }
    
    /// Replace the escape characters
    func replaceEscapeCharacters() -> String {
        return self.replacingOccurrences(of: "\n", with: "\\n").replacingOccurrences(of: "\t", with: "\\t").replacingOccurrences(of: "\r", with: "\\r")
    }
    
    /// Create CSV Row
    func formatCSVRow(_ div:String, value:Any) -> String {
        if let string = value as? String {
            // Wrap around double quotes
            let fString = "\(string)"
            return self.length == 0 ? fString  : "\(self)\(div)  \(fString)"
        } else {
            return self.length == 0 ? "\(value)" : "\(self)\(div)  \(value)"
        }
    }
    
    func stringByAppendingPathComponent(path: String) -> String {
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(path)
    }
}
