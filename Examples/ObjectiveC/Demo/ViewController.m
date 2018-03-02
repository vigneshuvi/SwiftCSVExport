//
//  ViewController.m
//  Demo
//
//  Created by Muthu on 2/25/18.
//  Copyright © 2018 Muthu. All rights reserved.
//

#import <objc/runtime.h>
#import "ViewController.h"

#import <SwiftCSVExport/SwiftCSVExport-Swift.h>

@interface User : NSObject

@property NSString *name;
@property NSString *email;

/*
 * GET dictionary from Object
 */
-(NSDictionary *)dictionary;

@end

@implementation User

-(NSDictionary *)dictionary {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:self.name forKey:@"name"];// you can give different key name here if you want
    [dict setValue:self.email forKey:@"email" ];
    
    return dict;
}

@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // First User Object
    NSMutableDictionary *user1 = [NSMutableDictionary new];
    [user1 setValue:@"vignesh" forKey:@"name" ];
    [user1 setValue:@"vigneshuvi@gmail.com" forKey: @"email"];
    

    
    
    
    
    User *user2 = [User new];
    user2.name = @"John";
    user2.email = @"John@gmail.com";

    
    // Secound User Object
    NSMutableDictionary *user3 = [NSMutableDictionary new];
    [user3 setValue:@"name" forKey:@"name" ];
    [user3 setValue:@"email" forKey: @"email"];
    
    
    
    // CSV fields Array
    NSMutableArray *fields = [NSMutableArray new];
    [fields addObject:@"name"];
    [fields addObject:@"email"];
    
    // CSV rows Array
    NSMutableArray *data = [NSMutableArray new];
    [data addObject:user1];
    [data addObject:[user2 dictionary]];
    [data addObject:user3];
    
    

    
    // Create a object for write CSV
    CSV *writeCSVObj = [[CSV alloc] init];
    writeCSVObj.rows = data;
    writeCSVObj.fields = fields;
    //writeCSVObj.delimiter = DividerTypeComma;
    writeCSVObj.name = @"userlist";
    
    // Write File using CSV class object
    CSVResult *outPut = [CSVExport export:writeCSVObj];
    if (outPut.result == ResultValid) {
       NSLog(@"Export Validate.");
    } else {
        NSLog(@"Export Invalidate.");
    }
    // REad cSv file
    CSV *readCSV = [CSVExport readCSVObjectFromDefaultPath:@"userlist.csv"];
    if (readCSV != nil) {
        NSLog(@"Export Validate.");
    } else {
        NSLog(@"Export Invalidate.");
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
