//
//  TouchDrawView.h
//  TouchTracker
//
//  Created by rhino Q on 22/09/2019.
//  Copyright © 2019 rhino Q. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Line;

NS_ASSUME_NONNULL_BEGIN

@interface TouchDrawView : UIView<UIGestureRecognizerDelegate>
{
    NSMutableDictionary *linesInProcess;
    NSMutableArray *completeLines;
    UIPanGestureRecognizer *moveRecognizer;
}

-(void)clearAll;
-(void)endTouches:(NSSet *)touches;

@property (nonatomic, weak) Line *selectedLine;
-(Line *)lineAtPoint:(CGPoint)p;

@end

NS_ASSUME_NONNULL_END
