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

typedef NS_ENUM(int, RSSType) {
    RSSTypeBNR,
    RSSTypeApple
};

@interface ViewController : UITableViewController

@property (nonatomic) RSSChannel *channel;
@property (nonatomic, strong) WebViewController *webViewController;
@property (nonatomic) RSSType rssType;

-(void)fetchEntries;

@end

@protocol ViewControllerDelegate
-(void)listViewController:(ViewController *)lvc handleObject:(id)object;
@end

