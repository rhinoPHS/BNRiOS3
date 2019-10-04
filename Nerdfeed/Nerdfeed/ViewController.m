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

@interface ViewController ()

@end

@implementation ViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if(self) {
        [self fetchEntries];
    }
    return self;
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
    [[self navigationController] pushViewController:_webViewController animated:YES];
    
    RSSItem *entry = [[_channel items] objectAtIndex:[indexPath row]];
    
    NSURL *url = [NSURL URLWithString:entry.link];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [_webViewController.webView loadRequest:req];
    _webViewController.navigationItem.title = entry.title;
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
