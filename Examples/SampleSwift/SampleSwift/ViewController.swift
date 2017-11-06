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
    
    var task: String = ""
    
    var tasks: String = ""
    
    
    var DMID: String = "123456789"
    var RECORDID: String = "PCA12345D"
    var First : String = "Leah"
    var Last : String = "Schmidt"
    var Company: String = "Lab Cab Inc"
    var Address1 : String = " 5442 Appaloosa Way"
    var Address2 : String = "First Floor"
    var City : String = "Loma Linda"
    var State : String = "Missouri"
    var Postalcode : String = "64804"
    var Country: String = "USA"
    var Sender:String = "Annie"
    var Frontimage : String = "Picture of Roo"
    var Backtext : String =  "\nHi Leah\n Here is a photo of ROO\n Love\n Leah\n" 
    var Accentimage : String = " NO Accentimage"
    var Backimage : String = "NO Backimage"
    
    @IBOutlet var webview: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //   First User Object
        let user1:NSMutableDictionary = NSMutableDictionary()
        
        user1.setObject(DMID, forKey: "DMID" as NSCopying);               //required
        user1.setObject(RECORDID, forKey: "RecordID" as NSCopying);          //required
        user1.setObject(First, forKey: "First" as NSCopying);              //required
        user1.setObject(Last, forKey: "Last" as NSCopying);                //required
        user1.setObject(Company, forKey: "Company" as NSCopying);   //required
        user1.setObject(Address1, forKey: "Address1" as NSCopying); //required
        user1.setObject(Address2, forKey: "Address2" as NSCopying);          //optional
        user1.setObject(City, forKey: "City" as NSCopying);             //required
        user1.setObject(State, forKey: "State" as NSCopying);              //required
        user1.setObject(Postalcode, forKey: "Postalcode" as NSCopying);            //required
        user1.setObject(Country, forKey: "Country" as NSCopying);       //optional
        user1.setObject(Sender, forKey: "Sender" as NSCopying);                //optional
        user1.setObject(Frontimage, forKey: "Frontimage" as NSCopying);      //required
        user1.setObject(Backtext, forKey: "Backtext" as NSCopying);          //optional
        user1.setObject(Accentimage, forKey: "Accentimage" as NSCopying);    //optional
        user1.setObject(Backimage, forKey: "Backimage" as NSCopying);        //optional
        
    
        // CSV rows Array
        let data:NSMutableArray  = NSMutableArray()
        data.add(user1);

        
        let filePath:String = SwiftCSVExport.exportCSV("userlist1",fields: ["DMID", "RecordID", "First", "Last", "Company","Address1", "Address2", "City", "State", "Postalcode", "Country", "Sender","Frontimage", "Backtext", "Accentimage", "Backimage"],values: data);
        
        print(filePath)
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
    var csvText = "DMID, RecordID, First, Last, Street,Apt., City, State, Postalcode\n"
    
    
}
