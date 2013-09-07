//
//  ViewController.h
//  CrawlMe
//
//  Created by Abdurrahman Ghanem on 9/6/13.
//  Copyright (c) 2013 Abdurrahman Ghanem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DisplayResultViewController.h"
#import "URLDownloader.h"
#import "CrawlingDelegate.h"
#import "globals.h"

@interface URLInputViewController : UIViewController <CrawlingDelegate , UITextFieldDelegate>
{
    DisplayResultViewController * _displayResultsViewController ;
//    UINavigationController * _navigationController ;
    NSOperationQueue * operationQueue ;
    
    NSMutableDictionary * _pages ;
    NSString * _parentUrl ;
}

@property ( nonatomic , readwrite ) IBOutlet UITextField * input ;

-(IBAction)startCrawling:(id)sender ;

@end
