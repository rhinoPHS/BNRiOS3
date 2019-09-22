//
//  TouchDrawView.m
//  TouchTracker
//
//  Created by rhino Q on 22/09/2019.
//  Copyright © 2019 rhino Q. All rights reserved.
//

#import "TouchDrawView.h"
#import "Line.h"

@implementation TouchDrawView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        linesInProcess = [[NSMutableDictionary alloc] init];
        completeLines = [[NSMutableArray alloc] init];
        
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setMultipleTouchEnabled:YES];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 10.0);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    // Draw complete lines in black
    [[UIColor blackColor] set];
    for(Line *line in  completeLines) {
        CGContextMoveToPoint(context, [line begin].x, [line begin].y);
        CGContextAddLineToPoint(context, [line end].x, [line end].y);
        CGContextStrokePath(context);
    }
    
    //Draw lines in process in red
    [[UIColor redColor] set];
    for(NSValue *v in linesInProcess) {
        Line *line = [linesInProcess objectForKey:v];
        CGContextMoveToPoint(context, [line begin].x, [line begin].y);
        CGContextAddLineToPoint(context, [line end].x, [line end].y);
        CGContextStrokePath(context);
    }
}

-(void)clearAll {
    [linesInProcess removeAllObjects];
    [completeLines removeAllObjects];
    
    // Redraw
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for(UITouch *t in touches) {
        // Is this a double tap?
        if([t tapCount] > 1) {
            [self clearAll];
//            [[self nextResponder] touchesBegan:touches withEvent:event]
            return;
        }
        
        // Use the touch object (packed in an NSValue) as the key
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        
        // Create a line for the value
        CGPoint loc = [t locationInView:self];
        Line *newLine = [[Line alloc] init];
        [newLine setBegin:loc];
        [newLine setEnd:loc];
        
        //Put pair in dictionary
        [linesInProcess setObject:newLine forKey:key];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // UPdate linesInProcess with moved touches
    for(UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        
        // Find the line for this touch
        Line *line = [linesInProcess objectForKey:key];
        //Update the line
        CGPoint loc = [t locationInView:self];
        [line setEnd:loc];
    }
    [self setNeedsDisplay];
}

- (void)endTouches:(NSSet *)touches {
    // Remove ending touches from dictionary
    for(UITouch *t in touches){
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        Line *line = [linesInProcess objectForKey:key];
        
        // If this is a double tap, 'line' will be nil,
        // so make sure not to add it to the array
        if(line) {
            [completeLines addObject:line];
            [linesInProcess removeObjectForKey:key];
        }
    }
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endTouches:touches];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endTouches:touches];
}

@end
