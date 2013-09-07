//
//  URLDownloader.m
//  CrawlMe
//
//  Created by Abdurrahman Ghanem on 9/6/13.
//  Copyright (c) 2013 Abdurrahman Ghanem. All rights reserved.
//

#import "URLDownloader.h"

@interface URLDownloader (Private)

-(NSArray*)extractURLs:(NSString*)htmlString ;
-(BOOL)checkProtocolExistence:(NSString*)url ;
-(BOOL)isMultimediaResource:(NSString*)url ;

@end

@implementation URLDownloader

@synthesize delegate = _delegate ;
@synthesize parentPage = _parentPage ;

-(id)init
{
    if ( self = [super init] )
    {
        receivedData = [[NSMutableData alloc] init] ;
        _parentPage = nil ;
    }
    
    return self ;
}

-(void)startDownloading:(NSString*)url
{
    NSLog(@"started downloading page: %@", url) ;
    if ( ![self checkProtocolExistence:url] )
        url = [@"http://" stringByAppendingString:url] ;
    
    NSError *theError = nil ;
    NSURLResponse *theResponse = nil ;
    
    if ( [self isMultimediaResource:url] )
    {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120.0f];
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&theResponse error:&theError];
        
        if ( data.length )
        {
            Page * page = [[Page alloc] init] ;
            page.url = url ;
            page.childUrls = nil ;
            page.content = data ;
            page.parent = _parentPage ;
            
            [_delegate parsingPageFinished:page] ;
        }
    }
    else
    {
        NSString * htmlContent = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:url] encoding:NSASCIIStringEncoding error:&theError] ;
        
        if ( htmlContent.length > 0 )
        {
            NSArray * result = [self extractURLs:htmlContent] ;
            
            Page * page = [[Page alloc] init] ;
            page.url = url ;
            page.childUrls = result ;
            page.content = htmlContent ;
            page.parent = _parentPage ;
            
            [_delegate parsingPageFinished:page] ;
        }

    }
}

#pragma mark connection methods

- (void)connection:(NSURLConnection *)conn didReceiveResponse:(NSURLResponse *)response
{
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [receivedData setLength:0] ;
    NSLog(@"error: %@", error.description) ;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{
	NSString * htmlContent = [[NSString alloc] initWithData:receivedData encoding:NSASCIIStringEncoding] ;
    
    if ( htmlContent.length > 0 )
    {
        NSArray * result = [self extractURLs:htmlContent] ;
        
        Page * page = [[Page alloc] init] ;
        page.url = [conn currentRequest].URL.absoluteString ;
        page.childUrls = result ;
        page.content = htmlContent ;
        page.parent = _parentPage ;
        
        [_delegate parsingPageFinished:page] ;
    }
}

#pragma mark priavte methods

-(NSArray*)extractURLs:(NSString*)htmlString
{
    NSDataDetector *linkDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
    NSArray *matches = [linkDetector matchesInString:htmlString options:0 range:NSMakeRange(0, [htmlString length])];
    
    NSMutableArray * allMatches = [NSMutableArray arrayWithCapacity:[matches count]] ;
    
    for (NSTextCheckingResult *match in matches)
    {
        if ([match resultType] == NSTextCheckingTypeLink)
        {
            NSURL *url = [match URL];
            [allMatches addObject:url.absoluteString] ;
            NSLog(@"found URL: %@", url);
        }
    }
    
    return [NSArray arrayWithArray:allMatches] ;
}

-(BOOL)checkProtocolExistence:(NSString*)url
{
    if ( [url rangeOfString:@"http://"].location != NSNotFound ||
        [url rangeOfString:@"https://"].location != NSNotFound ||
        [url rangeOfString:@"ftp://"].location != NSNotFound )
    {
        return YES ;
    }
    
    return NO ;
    
//    NSString * regex = @"(http|https|ftp)://" ;
//    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    return [urlTest evaluateWithObject:url];
}

-(BOOL)isMultimediaResource:(NSString*)url
{
    NSArray * extensions = [NSArray arrayWithObjects:@".jpg" , @".jpeg" , @".png" , @".gif" , @".mov" , @".mp4" , nil] ;
    
    BOOL found = NO ;
    
    for (NSString *s in extensions)
    {
        if ([url rangeOfString:s].location != NSNotFound) {
            found = YES;
            break;
        }
    }
    
    return found ;
}

@end
