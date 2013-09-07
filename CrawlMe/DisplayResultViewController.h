//
//  DisplayResultViewController.h
//  CrawlMe
//
//  Created by Abdurrahman Ghanem on 9/6/13.
//  Copyright (c) 2013 Abdurrahman Ghanem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebpageViewController.h"
#import "Page.h"
#import "globals.h"

@interface DisplayResultViewController : UITableViewController
{
    NSMutableArray * _results ;
}

@property ( nonatomic , readonly ) NSMutableArray * results ;

-(void)refreshTable ;

@end
