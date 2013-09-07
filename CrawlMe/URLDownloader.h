//
//  URLDownloader.h
//  CrawlMe
//
//  Created by Abdurrahman Ghanem on 9/6/13.
//  Copyright (c) 2013 Abdurrahman Ghanem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CrawlingDelegate.h"
#import "globals.h"

@interface URLDownloader : NSObject <NSURLConnectionDelegate , NSURLConnectionDataDelegate>
{
    NSMutableData * receivedData ;
    __weak Page * _parentPage ;
    
    __weak id<CrawlingDelegate> _delegate ;
}

@property ( nonatomic , weak , readwrite ) id<CrawlingDelegate> delegate ;
@property ( nonatomic , weak , readwrite ) Page * parentPage ;

-(void)startDownloading:(NSString*)url ;

@end
