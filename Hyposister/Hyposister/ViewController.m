//
//  ViewController.m
//  Hyposister
//
//  Created by rhino Q on 21/09/2019.
//  Copyright © 2019 rhino Q. All rights reserved.
//

#import "ViewController.h"
#import "HypnosisView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    CGRect viewFrame = CGRectMake(160, 240, 100, 150);
//    HypnosisView *view = [[HypnosisView alloc] initWithFrame:viewFrame];
//    [view setBackgroundColor:[UIColor blueColor]];
//    [self.view addSubview:view];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
}

@end
