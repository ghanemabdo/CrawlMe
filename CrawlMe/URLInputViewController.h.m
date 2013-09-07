//
//  ViewController.m
//  CrawlMe
//
//  Created by Abdurrahman Ghanem on 9/6/13.
//  Copyright (c) 2013 Abdurrahman Ghanem. All rights reserved.
//

#import "URLInputViewController.h"

@interface URLInputViewController (Private)

-(BOOL)validateURL:(NSString*)url ;

@end

@implementation URLInputViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"CrawlMe" ;
    _pages = [[NSMutableDictionary alloc] initWithCapacity:100] ;
	
    _displayResultsViewController = [[DisplayResultViewController alloc] init] ;
    //[self addChildViewController:_displayResultsViewController] ;
    _displayResultsViewController.view.frame = self.view.bounds ;
    _displayResultsViewController.title = @"Crawled URLs" ;
    
    operationQueue = [[NSOperationQueue alloc] init] ;
    [operationQueue setMaxConcurrentOperationCount:10] ;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
    [operationQueue cancelAllOperations] ;
    
    [_displayResultsViewController.results removeAllObjects] ;
    [_displayResultsViewController refreshTable] ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)startCrawling:(id)sender
{
    NSString * url = [self.input text] ;
    
    if ( [self validateURL:url] &&
        self.navigationController.topViewController != _displayResultsViewController )
    {
        _parentUrl = url ;
        
        Page * page = [[Page alloc] init] ;
        page.parent = nil ;
        page.url = url ;
                
        URLDownloader * downloader = [[URLDownloader alloc] init] ;
        downloader.delegate = self ;
        downloader.parentPage = nil ;

        NSInvocationOperation * operation = [[NSInvocationOperation alloc] initWithTarget:downloader selector:@selector(startDownloading:) object:url] ;
        [operationQueue addOperation:operation] ;
        
        _displayResultsViewController.view.frame = self.view.bounds ;
        [self.navigationController pushViewController:_displayResultsViewController animated:YES] ;
    }
}

#pragma mark Crawling delegate

-(void)parsingPageFinished:(Page *)page
{
    if ( [_displayResultsViewController.results count] < MAX_CRAWL_RESULTS )
    {
        int remainingUrls = 0 ;
        
        NSLog(@"adding page: %@", page.url) ;
        @synchronized(_displayResultsViewController.results)
        {
            [_displayResultsViewController.results addObject:page] ;
            remainingUrls = MAX_CRAWL_RESULTS - [_displayResultsViewController.results count] ;
        }
        
        @synchronized(_pages)
        {
            [_pages setObject:page forKey:page.url] ;
        }
        
        if ( remainingUrls > 0 )
        {
            int count = MIN(remainingUrls , [page.childUrls count]) ;
            
            for ( int i = 0 ; i < count ; i++ )
            {
                NSString * url = [page.childUrls objectAtIndex:i] ;
                
                //check to remove cycles. remove already downloaded pages
                BOOL isDuplicate = NO ;
                
                @synchronized(_pages)
                {
                    if ( [_pages objectForKey:url] )
                        isDuplicate = YES ;
                }
                
                if ( !isDuplicate )
                {
                    URLDownloader * downloader = [[URLDownloader alloc] init] ;
                    downloader.delegate = self ;
                    downloader.parentPage = page ;
                    
                    NSInvocationOperation * operation = [[NSInvocationOperation alloc] initWithTarget:downloader selector:@selector(startDownloading:) object:url] ;
                    
                    @synchronized(operationQueue)
                    {
                        [operationQueue addOperation:operation] ;
                    }
                }
            }
        }
    }
    else
    {
        @synchronized(operationQueue)
        {
            [operationQueue cancelAllOperations] ;
        }
    }
}

#pragma mark TextField methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self startCrawling:nil] ;
    
    return YES;
}

#pragma mark private methods

-(BOOL)validateURL:(NSString*)url
{
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];
    return [urlTest evaluateWithObject:url];
}

@end
