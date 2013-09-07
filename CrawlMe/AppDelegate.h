//
//  AppDelegate.h
//  CrawlMe
//
//  Created by Abdurrahman Ghanem on 9/6/13.
//  Copyright (c) 2013 Abdurrahman Ghanem. All rights reserved.
//

#import <UIKit/UIKit.h>

@class URLInputViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) URLInputViewController *viewController;

@property (strong, nonatomic) UINavigationController * navigationController ;

@end
