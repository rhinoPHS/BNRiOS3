//
//  HypnosisView.h
//  Hyposister
//
//  Created by rhino Q on 21/09/2019.
//  Copyright © 2019 rhino Q. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface HypnosisView : UIView
{
    CALayer *boxLayer;
}
@property (nonatomic, strong) UIColor *circleColor;

@end

NS_ASSUME_NONNULL_END
