//
//  TimeViewController.m
//  HypnoTime
//
//  Created by rhino Q on 21/09/2019.
//  Copyright © 2019 rhino Q. All rights reserved.
//

#import "TimeViewController.h"

@interface TimeViewController () <CAAnimationDelegate>
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *timeButton;

@end

@implementation TimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"TimeViewController loaded its view.");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self slideInFromthesdeButton];
}

-(void)slideInFromthesdeButton {
    
    CABasicAnimation *mover = [CABasicAnimation animationWithKeyPath:@"position"];
    [mover setDelegate:self];
    [mover setDuration:0.5];
    [mover setFromValue:[NSValue valueWithCGPoint:CGPointMake(0.0, _timeButton.frame.origin.y + _timeButton.frame.size.height / 2)]];
//    [mover setToValue:[NSValue valueWithCGPoint:CGPointMake(100.0, 100.0)]];
    
    mover.removedOnCompletion = NO;
    [[_timeButton layer] addAnimation:mover forKey:@"slide"];
}

- (IBAction)showCurrentTime:(UIButton *)sender {
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    [_timeLabel setText:[formatter stringFromDate:now]];
    
//    [self spinTimeLabel];
    [self bounceTimeLabel];
}

- (void)spinTimeLabel {
    // Create a basic animation
    CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    // fromValue is implied
    [spin setToValue:[NSNumber numberWithFloat:M_PI * 2.0]];
    [spin setDuration:1.0];
    [spin setDelegate:self];
    
    CAMediaTimingFunction *tf = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [spin setTimingFunction:tf];
    // Kick off the animation by adding it to the layer
    [[_timeLabel layer] addAnimation:spin forKey:@"spinAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if(anim == [[_timeButton layer] animationForKey:@"slide"] || flag == YES) {
        NSLog(@"slide finished");
        anim = nil;
        
        CABasicAnimation *fader = [CABasicAnimation animationWithKeyPath:@"opacity"];
        [fader setDuration:0.6];
        [fader setFromValue:[NSNumber numberWithFloat:1.0]];
        [fader setToValue:[NSNumber numberWithFloat:0.0]];
        [fader setRepeatCount:INFINITY];
        [[_timeButton layer] addAnimation:fader forKey:@"fader"];
    }
    NSLog(@"%@ finished: %d",anim, flag);
}

- (void)bounceTimeLabel {
    CAKeyframeAnimation *bounce = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    //Create the values it will pass through
    CATransform3D forward = CATransform3DMakeScale(1.3, 1.3, 1);
    CATransform3D back = CATransform3DMakeScale(0.7, 0.7, 1);
    CATransform3D forward2 = CATransform3DMakeScale(1.2, 1.2, 1);
    CATransform3D back2 = CATransform3DMakeScale(0.9, 0.9, 1);
    
    [bounce setValues:[NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DIdentity],
                       [NSValue valueWithCATransform3D:forward],
                       [NSValue valueWithCATransform3D:back],
                       [NSValue valueWithCATransform3D:forward2],
                       [NSValue valueWithCATransform3D:back2],
                       [NSValue valueWithCATransform3D:CATransform3DIdentity],
                       nil]];
    
    [bounce setDuration:0.6];
    
    CABasicAnimation *fader = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [fader setDuration:0.6];
    [fader setFromValue:[NSNumber numberWithFloat:1.0]];
    [fader setToValue:[NSNumber numberWithFloat:0.0]];
    
    CABasicAnimation *appear = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [fader setDuration:0.6];
    [fader setFromValue:[NSNumber numberWithFloat:0.0]];
    [fader setToValue:[NSNumber numberWithFloat:1.0]];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    [group setAnimations:[NSArray arrayWithObjects:fader, bounce, nil]];
    
    [group setDelegate:self];
    
    // Animate the layer
    [[_timeLabel layer] addAnimation:group forKey:@"bounceAnimation"];
}



@end
