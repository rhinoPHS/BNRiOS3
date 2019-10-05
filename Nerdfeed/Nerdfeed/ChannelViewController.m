//
//  ChannelViewController.m
//  Nerdfeed
//
//  Created by rhino Q on 05/10/2019.
//  Copyright © 2019 rhino Q. All rights reserved.
//

#import "ChannelViewController.h"
#import "RSSChannel.h"

@interface ChannelViewController ()

@end

@implementation ChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)listViewController:(ViewController *)lvc handleObject:(id)object {
    if(![object isKindOfClass:[RSSChannel class]])
        return;
    
    _channel = object;
    [self.tableView reloadData];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if(!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"UITableVieCell"];
    
    if([indexPath row] == 0) {
        [[cell textLabel] setText:@"Title"];
        [[cell detailTextLabel] setText:_channel.title];
    } else {
        [[cell textLabel] setText:@"Info"];
        [[cell detailTextLabel] setText:_channel.infoString];
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (void)splitViewController:(UISplitViewController *)svc willChangeToDisplayMode:(UISplitViewControllerDisplayMode)displayMode {
    if(displayMode == UISplitViewControllerDisplayModePrimaryHidden) {
        self.navigationItem.leftBarButtonItem = svc.displayModeButtonItem;
    }
}


@end
