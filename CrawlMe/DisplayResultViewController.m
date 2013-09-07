//
//  DisplayResultViewController.m
//  CrawlMe
//
//  Created by Abdurrahman Ghanem on 9/6/13.
//  Copyright (c) 2013 Abdurrahman Ghanem. All rights reserved.
//

#import "DisplayResultViewController.h"

@interface DisplayResultViewController ()

@end

@implementation DisplayResultViewController

@synthesize results = _results ;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _results = [[NSMutableArray alloc] initWithCapacity:MAX_CRAWL_RESULTS] ;
    
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(refreshTable) userInfo:nil repeats:YES] ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshTable
{
    if ( [_results count] > 0 )
    {
        [self.tableView reloadData] ;
        [self.tableView setNeedsDisplay] ;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_results count] ;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if(indexPath.section == 0)
    {
        if ( indexPath.row < [_results count] )
        {
            Page * page = [_results objectAtIndex:indexPath.row] ;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator ;
            
            UILabel * urlLabel = [[UILabel alloc] initWithFrame:CGRectMake(5 , 10 , 210 , 60)] ;
            urlLabel.numberOfLines = 3 ;
            urlLabel.text = [NSString stringWithFormat:@"URL: %@", page.url] ;
            [urlLabel setAdjustsFontSizeToFitWidth:YES] ;
            urlLabel.textColor = [UIColor grayColor] ;
            [cell addSubview:urlLabel] ;
            
            UILabel * contentSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(225 , 10 , 70 , 60)] ;
            contentSizeLabel.numberOfLines = 3 ;
            if ( [page.content isKindOfClass:[NSString class]] )
                contentSizeLabel.text = [NSString stringWithFormat:@"Size: %lu chars", (unsigned long)((NSString*)page.content).length] ;
            else
            {
                NSData * data = ((NSData*)page.content) ;
                contentSizeLabel.text = [NSString stringWithFormat:@"Size: %lu bytes", (unsigned long)data.length] ;
            }
            [contentSizeLabel setAdjustsFontSizeToFitWidth:YES] ;
            contentSizeLabel.textColor = [UIColor blackColor] ;
            [cell addSubview:contentSizeLabel] ;
        }
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if ( indexPath.row < [_results count] )
        {
            Page * page = [_results objectAtIndex:indexPath.row] ;
            
            WebpageViewController * webpage = [[WebpageViewController alloc] initWithNibName:@"WebpageViewController" bundle:nil] ;
            webpage.view.frame = self.view.bounds ;
            webpage.webView.scalesPageToFit = YES ;
            [webpage.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:page.url]]] ;
            
            [self.navigationController pushViewController:webpage animated:YES] ;
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES] ;
}

@end
