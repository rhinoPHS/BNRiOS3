//
//  ImageViewController.h
//  Homepwner
//
//  Created by rhino Q on 19/09/2019.
//  Copyright © 2019 rhino Q. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@end

NS_ASSUME_NONNULL_END
