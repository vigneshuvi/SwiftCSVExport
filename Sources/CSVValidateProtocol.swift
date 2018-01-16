//
//  CSVValidateProtocol.swift
//  SwiftCSVExport
//
//  Created by Vignesh on 12/01/18.
//  Copyright © 2018 vigneshuvi. All rights reserved.
//

import Foundation

// MARK: - Enumaration Result - For Give back reponse.
public enum Result<Value> {
    case valid(Value)
    case invalid(Value)
    
    /// Returns the associated value if the result is a fail, `nil` otherwise.
    public var value: Value? {
        switch self {
        case .valid(let value):
            return value
        case .invalid(let value):
            return value
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

// MARK: - CSV Validation Protocol - Method Declaration
protocol CSVValidationProtocol {
    func getSuccessMessage(_ row: Int, count: Int) -> String
    func getErrorMessage(_ row: Int, hCount: Int, rCount: Int) -> String
    func validateRow(_ headerColumnCount: Int, rowColumnCount:Int, row:Int) -> Result<String>
}

// MARK: - CSV Validation Protocol - Method Definition
extension CSVValidationProtocol {
    
    func getSuccessMessage(_ row: Int, count: Int) -> String {
        return  "Row \(row) have valid columns(\(count)) count"
    }
    
    func getErrorMessage(_ row: Int, hCount: Int, rCount: Int) -> String {
        return  "Expected \(hCount) columns, But Parsed \(rCount) columns on row \(row)"
    }
    
    func validateRow(_ headerColumnCount: Int = -1, rowColumnCount:Int = -1, row:Int = -1) -> Result<String> {
        if (headerColumnCount > 0 && headerColumnCount == rowColumnCount) {
            return Result.valid(getSuccessMessage(row, count: headerColumnCount))
        } else {
            return Result.invalid(getErrorMessage(row, hCount: headerColumnCount, rCount: rowColumnCount))
        }
    }
}
