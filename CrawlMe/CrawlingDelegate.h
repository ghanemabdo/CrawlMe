//
//  CawlingDelegate.h
//  CrawlMe
//
//  Created by Abdurrahman Ghanem on 9/6/13.
//  Copyright (c) 2013 Abdurrahman Ghanem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Page.h"

@protocol CrawlingDelegate <NSObject>

-(void)parsingPageFinished:(Page*)page ;

@end
