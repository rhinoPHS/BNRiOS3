//
//  TouchDrawView.h
//  TouchTracker
//
//  Created by rhino Q on 22/09/2019.
//  Copyright © 2019 rhino Q. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TouchDrawView : UIView
{
    NSMutableDictionary *linesInProcess;
    NSMutableArray *completeLines;
}

-(void)clearAll;
-(void)endTouches:(NSSet *)touches;

@end

NS_ASSUME_NONNULL_END
