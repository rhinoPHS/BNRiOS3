//
//  TimeViewController.m
//  HypnoTime
//
//  Created by rhino Q on 21/09/2019.
//  Copyright © 2019 rhino Q. All rights reserved.
//

#import "TimeViewController.h"

@interface TimeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation TimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"TimeViewController loaded its view.");
}
- (IBAction)showCurrentTime:(UIButton *)sender {
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    [_timeLabel setText:[formatter stringFromDate:now]];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
