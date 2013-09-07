//
//  WebpageViewController.h
//  CrawlMe
//
//  Created by Abdurrahman Ghanem on 9/7/13.
//  Copyright (c) 2013 Abdurrahman Ghanem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebpageViewController : UIViewController <UIWebViewDelegate>
{
    UIWebView * _webView ;
}

@property (nonatomic , strong , readwrite) IBOutlet UIWebView * webView ;

@end
