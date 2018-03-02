//
//  CSVValidateProtocol.swift
//  SwiftCSVExport
//
//  Created by Vignesh on 12/01/18.
//  Copyright © 2018 vigneshuvi. All rights reserved.
//

import Foundation

// MARK: - Enumaration Result - For Give back reponse.
@objc public enum Result: Int  {
    public typealias RawValue = String
    case valid
    case invalid
    
    public var rawValue: RawValue {
        switch self {
        case .valid:
            return "valid"
        case .invalid:
            return "invalid"
        }
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "valid":
            self = .valid
        case "invalid":
            self = .invalid
        default:
            self = .invalid
        }
    }
    
    
    /// Returns `true` if the result is a success, `false` otherwise.
    public var isSuccess: Bool {
        switch self {
        case .valid:
            return true
        case .invalid:
            return false
        }
    }
    
    /// Returns `true` if the result is a failure, `false` otherwise.
    public var isFailure: Bool {
        return !isSuccess
    }
}

@objc open class CSVResult: NSObject  {
    
    /// The name of the csv files.
    @objc open var result:Result = .valid;
    @objc open var message:String;
    @objc open var filePath:String!;
    
    public init?(_ isValid: Bool, message:String = "") {
        if isValid {
            self.result = .valid
        } else {
            self.result = .invalid
        }
        self.message = message
        self.filePath = nil
    }
    
    public init?(_ isValid: Bool, message:String = "", filePath:String = "") {
        if isValid {
            self.result = .valid
        } else {
            self.result = .invalid
        }
        self.message = message
        self.filePath = filePath
    }
}

// MARK: - CSV Validation Protocol - Method Declaration
protocol CSVValidationProtocol {
    func getSuccessMessage(_ row: Int, count: Int) -> String
    func getErrorMessage(_ row: Int, hCount: Int, rCount: Int) -> String
    func validateRow(_ headerColumnCount: Int, rowColumnCount:Int, row:Int) -> CSVResult
}

// MARK: - CSV Validation Protocol - Method Definition
extension CSVValidationProtocol {
    
    func getSuccessMessage(_ row: Int, count: Int) -> String {
        return  "Row \(row) have valid columns(\(count)) count"
    }
    
    func getErrorMessage(_ row: Int, hCount: Int, rCount: Int) -> String {
        return  "Expected \(hCount) columns, But Parsed \(rCount) columns on row \(row)"
    }
    
    func validateRow(_ headerColumnCount: Int = -1, rowColumnCount:Int = -1, row:Int = -1) -> CSVResult {
        if (headerColumnCount > 0 && headerColumnCount == rowColumnCount) {
            return CSVResult.init(true, message:(getSuccessMessage(row, count: headerColumnCount)))!
        } else {
            return CSVResult.init(false, message:(getErrorMessage(row, hCount: headerColumnCount, rCount: rowColumnCount)))!
            
        }
    }
}
