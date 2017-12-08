//
//  SwiftCSVExportTests.swift
//  SwiftCSVExportTests
//
//  Created by Vignesh on 07/02/17.
//  Copyright © 2017 vigneshuvi. All rights reserved.
//

import XCTest
@testable import SwiftCSVExport

class SwiftCSVExportTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        self.testExample()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Able to convert JSON string into CSV.
        let numberArray = [["a": 1, "b": 2, "c": 3],
        ["a": 4, "b": 5, "c": 6],
        ["a": 7, "b": 8, "c": 9]]
        let fields =  ["a", "b","c"];
        
        let path:String = SwiftCSVExport.exportCSV("numberList",fields: fields,values: numberArray);
        print(path)
        
        // Read CSV as NSMutableDictionary object
        let numberDetails = readCSV(path);
        if numberDetails.allKeys.count > 0 {
            print(numberDetails)
        }
        
        // Read CSV as CSV class object
        let csvObj = readCSVObject(path);
        loggly(LogType.Info, text: csvObj.name)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
