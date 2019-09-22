//
//  ViewController.m
//  TouchTracker
//
//  Created by rhino Q on 22/09/2019.
//  Copyright © 2019 rhino Q. All rights reserved.
//

#import "ViewController.h"
#import "TouchDrawView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)loadView {
    [self setView:[[TouchDrawView alloc] initWithFrame:CGRectZero]];
}


@end
