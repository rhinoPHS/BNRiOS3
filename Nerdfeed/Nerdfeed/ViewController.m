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
        [self fetchEntries];
    }
    return self;
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
    _xmlData = [[NSMutableData alloc] init];
    
    NSURL *url = [NSURL URLWithString:@"https://www.cocoawithlove.com/feed.xml"];
//    NSURL *url = [NSURL URLWithString:@"https://www.apple.com/newsroom/rss-feed.rss"];
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    
    __weak ViewController *weakSelf = self;
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error);
            return;
        }
        
        if(data) {
            [weakSelf.xmlData appendData:data];
            NSString *xmlCheck = [[NSString alloc] initWithData:weakSelf.xmlData encoding:NSUTF8StringEncoding];
            NSLog(@"xmlCheck = %@", xmlCheck);
            
            NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
            [parser setDelegate:self];
            [parser parse];
            data = nil;
            dispatch_async(dispatch_get_main_queue(), ^{
               [[self tableView] reloadData];
            });
            
            NSLog(@"abcchannel : %@\n abcchannelTitle : %@\n abcinfoString : %@\n", weakSelf.channel, [weakSelf.channel title], [weakSelf.channel infoString]);
        }
    }];
    [task resume];
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
    
//    NSURL *url = [NSURL URLWithString:entry.link];
//    NSURLRequest *req = [NSURLRequest requestWithURL:url];
//    [_webViewController.webView loadRequest:req];
//    _webViewController.navigationItem.title = entry.title;
    [_webViewController listViewController:self handleObject:entry];
}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    NSLog(@"%@ found a %@ element", self, elementName);
    if([elementName isEqualToString:@"channel"]) {
        _channel = [RSSChannel new];
        
        [_channel setParentParserDelegate:self];
        
        [parser setDelegate:_channel];
    }
}

@end
