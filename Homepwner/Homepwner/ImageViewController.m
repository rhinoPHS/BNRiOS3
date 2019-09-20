//
//  ImageViewController.m
//  Homepwner
//
//  Created by rhino Q on 19/09/2019.
//  Copyright © 2019 rhino Q. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()<UIScrollViewDelegate>

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGSize sz = [[self image] size];
    [_scrollView setContentSize:CGSizeMake(600, 600)];
    [_imageView setFrame:CGRectMake(0, 0, sz.width, sz.height)];
    [_imageView setImage:_image];
    [_imageView sizeToFit];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)setScrollView:(UIScrollView *)scrollView {
    _scrollView = scrollView;
    _scrollView.minimumZoomScale = 0.2;
    _scrollView.maximumZoomScale = 2.0;
    _scrollView.delegate = self;
    _scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
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
