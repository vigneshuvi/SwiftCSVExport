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

class ViewController: UIViewController {

    @IBOutlet var webview: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        webview.loadRequest(NSURLRequest(url: NSURL(string: "https://github.com/vigneshuvi/SwiftCSVExport/blob/master/README.md")! as URL) as URLRequest)

        // First User Object
        let user1:NSMutableDictionary = NSMutableDictionary()
        user1.setObject("vignesh", forKey: "name" as NSCopying);
        user1.setObject("vigneshuvi@gmail.com", forKey: "email" as NSCopying);
        
        // Secound User Object
        let user2:NSMutableDictionary = NSMutableDictionary()
        user2.setObject("vinoth", forKey: "name" as NSCopying);
        user2.setObject("vinoth@gmail.com", forKey: "email" as NSCopying);
        
        // CSV fields Array
        let fields:NSMutableArray = NSMutableArray()
        fields.add("name");
        fields.add("email");
        
        // CSV rows Array
        let data:NSMutableArray  = NSMutableArray()
        data.add(user1);
        data.add(user2);
        
        let userpath:String = SwiftCSVExport.exportCSV("userlist1",fields: fields, values: data);
        print(userpath)
        
        let namepath:String = SwiftCSVExport.exportCSV("userlist1",fields: ["name", "email"], values: data);
        print(namepath)
        
        // Able to convert JSON string into CSV.
        let string = "[{\"name\":\"vignesh\",\"email\":\"vigneshuvi@gmail.com\"},{\"name\":\"vinoth\",\"email\":\"vinoth@gmail.com\"}]";
        let filePath:String = exportCSV("userlist", fields:["name","email"], values:string);
        print(filePath)
        
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

