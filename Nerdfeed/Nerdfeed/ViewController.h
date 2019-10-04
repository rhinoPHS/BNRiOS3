//
//  ViewController.h
//  Nerdfeed
//
//  Created by rhino Q on 27/09/2019.
//  Copyright © 2019 rhino Q. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RSSChannel;
@class WebViewController;

@interface ViewController : UITableViewController <NSXMLParserDelegate>
//{
//    NSURLConnection *connection;
//    NSMutableData *xmlData;
//}

//@property (nonatomic)  NSURLConnection *connection;
@property (nonatomic)  NSMutableData *xmlData;
@property (nonatomic) RSSChannel *channel;
@property (nonatomic, strong) WebViewController *webViewController;

-(void)fetchEntries;


@end

