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
        let string = "[{\"name\":\"vignesh\",\"email\":\"vigneshuvi@gmail.com\"},{\"name\":\"vinoth\",\"email\":\"vinoth@gmail.com\"}]";
        let filePath:String = exportCSV("userlist", fields:["name","email"], values:string);
        print(filePath)
        
        let fileDetails = readCSV(filePath);
        if fileDetails.allKeys.count > 0 {
            print(fileDetails)
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
