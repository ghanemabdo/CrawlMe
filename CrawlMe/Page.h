//
//  Page.h
//  CrawlMe
//
//  Created by Abdurrahman Ghanem on 9/6/13.
//  Copyright (c) 2013 Abdurrahman Ghanem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Page : NSObject
{
    __weak Page * _parent ;
    NSArray * _childUrls ;
    NSString * _url ;
    id _content ;
}

@property ( nonatomic , weak , readwrite ) Page * parent ;
@property ( nonatomic , strong , readwrite ) NSArray * childUrls ;
@property ( nonatomic , strong , readwrite ) NSString * url ;
@property ( nonatomic , strong , readwrite ) id content ;

@end
