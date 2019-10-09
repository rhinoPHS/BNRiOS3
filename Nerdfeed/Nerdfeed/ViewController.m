//
//  ViewController.m
//  Nerdfeed
//
//  Created by rhino Q on 27/09/2019.
//  Copyright © 2019 rhino Q. All rights reserved.
//

#import "ViewController.h"
#import "RSSChannel.h"
#import "RSSItem.h"
#import "WebViewController.h"
#import "ChannelViewController.h"
#import "BNRFeedStore.h"

@interface ViewController ()

@end

@implementation ViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if(self) {
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:@"Info"
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(showInfo:)];
        [[self navigationItem] setRightBarButtonItem:bbi];
        
        UISegmentedControl *rssTypeControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"BNR", @"Apple", nil]];
        [rssTypeControl setSelectedSegmentIndex:0];
        [rssTypeControl addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventValueChanged];
        [[self navigationItem] setTitleView:rssTypeControl];
        
        [self fetchEntries];
    }
    return self;
}

-(void)changeType:(id)sender {
    _rssType = (RSSType)[sender selectedSegmentIndex];
    [self fetchEntries];
}

-(void)showInfo:(id)sender {
    ChannelViewController *channelVC = [[ChannelViewController alloc] initWithStyle:UITableViewStyleGrouped];
    if([self splitViewController]) {
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:channelVC];
        
        NSArray *vcs = [NSArray arrayWithObjects:self.navigationController,nvc, nil];
        
        [[self splitViewController] setViewControllers:vcs];
        
        //Make detail view controller the delegate of the spit view controller
        [[self splitViewController] setDelegate:channelVC];
        
        // if a row has been seleted, deselect it so that a row
        // is not selected when viewing the info
        NSIndexPath *seletedRow = [[self tableView]indexPathForSelectedRow];
        if(seletedRow) {
            [[self tableView] deselectRowAtIndexPath:seletedRow animated:YES];
        }
    } else {
        [[self navigationController] pushViewController:channelVC animated:YES];
    }
    [channelVC listViewController:self handleObject:self.channel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)fetchEntries {
    UIView *currentTitleView = self.navigationItem.titleView;
    UIActivityIndicatorView *aiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.navigationItem setTitleView:aiView];
    [aiView startAnimating];
    
    
    
    __weak ViewController *weakSelf = self;
    
    void (^compltetionBlock)(RSSChannel * _Nonnull obj, NSError * _Nonnull err) = ^(RSSChannel * _Nonnull obj, NSError * _Nonnull err) {
        NSLog(@"Completion block called!");
        
        if(!err) {
            weakSelf.channel = obj;
            dispatch_async(dispatch_get_main_queue(), ^{
                 [self.navigationItem setTitleView:currentTitleView];
                [[self tableView] reloadData];
            });
        } else {
            NSLog(@"error in fetchTopSongs : %@", err);
        }
    };
    if(_rssType == RSSTypeBNR) {
//        _channel = [[BNRFeedStore sharedStore] fetchRSSFeedWithCompletion:compltetionBlock];
//        [self.tableView reloadData];
        
        _channel = [[BNRFeedStore sharedStore] fetchRSSFeedWithCompletion:^(RSSChannel * _Nonnull obj, NSError * _Nonnull err) {
            NSLog(@"Completion block called! RSSTypeBNR");
            // Replace the activity indicator.

            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationItem setTitleView:currentTitleView];
            });

            if(!err) {
                // How many items are there currnetly>
                int currentItemCount = (int)[weakSelf.channel.items count];

                //Set our channel to the mergedd one
                weakSelf.channel = obj;

                //How many items are there now?
                int newItemCount = (int)[weakSelf.channel.items count];

                //For each new item, insert a new row. The data source will take care of the rest.
                int itemDelta = newItemCount - currentItemCount;
                if(itemDelta > 0) {
                    NSMutableArray *rows = [NSMutableArray array];
                    for(int i=0; i<itemDelta; i++) {
                        NSIndexPath *ip = [NSIndexPath indexPathForItem:i inSection:0];
                        [rows addObject:ip];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView insertRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationTop];
                    });
                }
            }
        }];
        [self.tableView reloadData];
    } else if (_rssType == RSSTypeApple) {
        [[BNRFeedStore sharedStore] fetchTopSongs:10 withCompletioon:compltetionBlock];
    }
    NSLog(@"count : %d", (int)_channel.items.count);
    NSLog(@"Executing code at the end of fetchEntries");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_channel items] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return nil;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
    }
    
    RSSItem *item = [[_channel items] objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[item title]];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", item.author, item.category];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(![self splitViewController])
        [[self navigationController] pushViewController:_webViewController animated:YES];
    else {
        // We have to create a new navigation controllrer, as the old one
        // was only retained by the split view controller and is now gone
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_webViewController];
        
        NSArray *vcs = [NSArray arrayWithObjects:self.navigationController, nav, nil];
        [self.splitViewController setViewControllers:vcs];
        
        // Make the detail view controller the delegate of the split view controller
        // - ignore this warning
        [self.splitViewController setDelegate:_webViewController];
    }
    
    RSSItem *entry = [[_channel items] objectAtIndex:[indexPath row]];
    [_webViewController listViewController:self handleObject:entry];
}

@end
