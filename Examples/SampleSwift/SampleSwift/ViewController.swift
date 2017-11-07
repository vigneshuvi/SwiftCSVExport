//
//  ViewController.swift
//  SampleSwift
//
//  Created by qbuser on 30/01/17.
//  Copyright © 2017 vigneshuvi. All rights reserved.
//

import UIKit
import SwiftLoggly
import SwiftCSVExport

import UIKit
import SwiftLoggly
import SwiftCSVExport



class ViewController: UIViewController {
    
   
    
    @IBOutlet var webview: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Generate CSV file
        let user1:NSMutableDictionary = NSMutableDictionary()
        user1.setObject("vignesh", forKey: "name" as NSCopying);
        user1.setObject("vigneshuvi@gmail.com", forKey: "email" as NSCopying);
        user1.setObject("Hi Vignesh, \nhow are you? \t Shall we meet tomorrow? \r Thanks ", forKey: "address" as NSCopying);
        
        let user2:NSMutableDictionary = NSMutableDictionary()
        user2.setObject("vinoth", forKey: "name" as NSCopying);
        user2.setObject("vinoth@gmail.com", forKey: "email" as NSCopying);
        user2.setObject("Hi Vinoth, \nHow are you? \t Shall we meet tomorrow? \r Thanks ", forKey: "address" as NSCopying);

        
        let data:NSMutableArray  = NSMutableArray()
        data.add(user1);
        data.add(user2);
        
        let filePath:String = SwiftCSVExport.exportCSV("userlist",fields: ["name", "email", "address"],values: data);
        print(filePath)
        
        let request = NSURLRequest(url:  URL(fileURLWithPath: filePath) )
        webview.loadRequest(request as URLRequest)
        
        //
        let fileDetails = readCSV(filePath);
        if fileDetails.allKeys.count > 0 {
            loggly(LogType.Info, dictionary: fileDetails)
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
