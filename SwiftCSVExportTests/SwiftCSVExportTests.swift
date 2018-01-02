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
        // Generate CSV file
        let user1:NSMutableDictionary = NSMutableDictionary()
        user1.setObject(107, forKey: "userid" as NSCopying);
        user1.setObject("vignesh", forKey: "name" as NSCopying);
        user1.setObject("vigneshuvi@gmail.com", forKey: "email" as NSCopying);
        user1.setObject(true, forKey:"isValidUser" as NSCopying)
        user1.setObject("Hi 'Vignesh!', \nhow are you? \t Shall we meet tomorrow? \r Thanks ", forKey: "message" as NSCopying);
        user1.setObject(571.05, forKey: "balance" as NSCopying);
        
        let user2:NSMutableDictionary = NSMutableDictionary()
        user2.setObject(108, forKey: "userid" as NSCopying);
        user2.setObject("vinoth", forKey: "name" as NSCopying);
        user2.setObject(false, forKey:"isValidUser" as NSCopying)
        user2.setObject("vinoth@gmail.com", forKey: "email" as NSCopying);
        user2.setObject("Hi 'Vinoth!', \nHow are you? \t Shall we meet tomorrow? \r Thanks ", forKey: "message" as NSCopying);
        user2.setObject(567.50, forKey: "balance" as NSCopying);
        
        
        let data:NSMutableArray  = NSMutableArray()
        data.add(user1);
        data.add(user2);
        
        
        let header = ["userid", "name", "email", "message", "isValidUser","balance"]
        // Create a object for write CSV
        let writeCSVObj = CSV()
        writeCSVObj.rows = data
        writeCSVObj.fields = header as NSArray
        writeCSVObj.name = "userlist"
        
        // Write File using CSV class object
        let filePath:String = SwiftCSVExport.exportCSV(writeCSVObj);
        print(filePath)
        
        
        // Print read CSV object
        let fileDetails = readCSV(filePath);
        XCTAssertNotNil(fileDetails)
        XCTAssertTrue(fileDetails.hasData, "CSV file contains record")
        XCTAssertEqual(fileDetails.name, "userlist.csv")
        XCTAssertEqual(data.count, fileDetails.rows.count)
        XCTAssertEqual(header.count, fileDetails.fields.count)
        if fileDetails.hasData {
            print("\n\n***** CSV file contains record *****\n\n")
            print(fileDetails.name)
            print(fileDetails.fields)
            print(fileDetails.rows)
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            let fileDetails = readCSVFromDefaultPath("userlist.csv");
            XCTAssertNotNil(fileDetails)
            XCTAssertTrue(fileDetails.hasData, "CSV file contains record")
            XCTAssertEqual(fileDetails.name, "userlist.csv")
            XCTAssertEqual(2, fileDetails.rows.count)
            XCTAssertEqual(6, fileDetails.fields.count)
        }
    }
    
}
