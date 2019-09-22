//
//  ViewController.m
//  HypnoTime
//
//  Created by rhino Q on 21/09/2019.
//  Copyright © 2019 rhino Q. All rights reserved.
//

#import "HypnosisViewController.h"
#import "HypnosisView.h"
@interface HypnosisViewController ()

@end

@implementation HypnosisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"HypnosisViewController loaded its view.");
}

- (void)loadView {
    CGRect frame = [[UIScreen mainScreen] bounds];
    HypnosisView *v = [[HypnosisView alloc]initWithFrame:frame];
    
    [self setView:v];
}

//- (instancetype)initWithCoder:(NSCoder *)coder
//{
//    self = [super initWithCoder:coder];
//    if (self) {
//        NSLog(@"sfsdf");
//        [[self tabBarItem] setTitle:@"sdff"];
//    }
//    return self;
//}

@end
