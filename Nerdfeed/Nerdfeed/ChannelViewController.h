//
//  ChannelViewController.h
//  Nerdfeed
//
//  Created by rhino Q on 05/10/2019.
//  Copyright © 2019 rhino Q. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChannelViewController : UITableViewController <ViewControllerDelegate, UISplitViewControllerDelegate>

@property (nonatomic) RSSChannel *channel;

@end

NS_ASSUME_NONNULL_END
