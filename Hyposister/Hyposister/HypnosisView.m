//
//  HypnosisView.m
//  Hyposister
//
//  Created by rhino Q on 21/09/2019.
//  Copyright © 2019 rhino Q. All rights reserved.
//

#import "HypnosisView.h"

@implementation HypnosisView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setCircleColor:[UIColor lightGrayColor]];
        
        //Create the new layer object
        boxLayer = [[CALayer alloc] init];
        
        //Give it a size
        [boxLayer setBounds:CGRectMake(0.0, 0.0, 85.0, 85.0)];
        
        //Give it a location
        [boxLayer setPosition:CGPointMake(160.0, 100.0)];
        
        // Make half-trasparent red the backgound color for the layer
        UIColor *reddish = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.5];
        
        // Get a CGColor object with the same color values
        CGColorRef cgReddish = [reddish CGColor];
        [boxLayer setBackgroundColor:cgReddish];
        
        //Create a UIImage
        UIImage *layerImage = [UIImage imageNamed:@"Hypno.png"];
        //Get the underlyingCGImage
        CGImageRef image = [layerImage  CGImage];
        
        // Put the CGImage on the layer
        [boxLayer setContents:(__bridge id)image];
        
        // Inset the image a bit on each isde
        [boxLayer setContentsRect:CGRectMake(-0.1, -0.1, 1.2, 1.2)];
        // Let the image resize (without chaning the aspect ratio)
        // to fill the contentRect
        [boxLayer setContentsGravity:kCAGravityResizeAspect];
        
        // Make it a sublayer of the view's layer
        [[self layer] addSublayer:boxLayer];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *t = [touches anyObject];
    CGPoint p = [t locationInView:self];
//    CABasicAnimation *ba = [CABasicAnimation animationWithKeyPath:@"position"];
//    [ba setFromValue:[NSValue valueWithCGPoint:[boxLayer position]]];
//    [ba setToValue:[NSValue valueWithCGPoint:p]];
//    [ba setDuration:3.0];
    
    // Update the model layer
    [boxLayer setPosition:p];
    
    // Add animation that will gradually update presentation layer
//    [boxLayer addAnimation:ba forKey:@"foo"];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *t =[touches anyObject];
    CGPoint p = [t locationInView:self];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [boxLayer setPosition:p];
    [CATransaction commit];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect bounds = [self bounds];
    
    // Figure out the center of the bounds rectangle
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width / 2.0;
    center.y = bounds.origin.y + bounds.size.height / 2.0;
    
    // The radius of the circle should be nearly as big as the view
    float maxRadius = hypot(bounds.size.width, bounds.size.height) / 2.0;
    
    // The thickness of the line should be 10 points wide
    CGContextSetLineWidth(ctx, 10);
    
    // The color of the line should be gray (red/green/blud = 0.6, alha = 1.0);
//    CGContextSetRGBStrokeColor(ctx, 0.6, 0.6, 0.6, 1.0);
//    [[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1] setStroke];
//    [[UIColor lightGrayColor] setStroke];
    
    [[self circleColor] setStroke];
    
    // Add a shape to the context - this does not draw the shape
//    CGContextAddArc(ctx, center.x, center.y, maxRadius, 0.0, M_PI * 2.0, YES);
    
    //Perform ad drawing instruction; ddraw currnet sshape with currennt state
//    CGContextStrokePath(ctx);
    
    // Draw concentric circles from the outside in
    for(float currentRadius = maxRadius; currentRadius > 0; currentRadius -= 20) {
        // Add a path to the context
        CGContextAddArc(ctx, center.x, center.y, currentRadius, 0.0, M_PI * 2.0, YES);
        
        // Perform drawing instruction; remoevs path
        CGContextStrokePath(ctx);
    }
    
    NSString *text = @"You are getting sleepy";
    
    // Get a font to draw it in
    UIFont *font = [UIFont boldSystemFontOfSize:28];
    
    CGRect textRect;
    
    //How big is this string when drawn in this font?
    textRect.size = [text sizeWithAttributes:@{NSFontAttributeName : font}];
    
    // Let's put that string in the center of the view
    textRect.origin.x = center.x - textRect.size.width / 2.0;
    textRect.origin.y = center.y - textRect.size.height / 2.0;
    
    // Set the fill color of the current context to black
    [[UIColor blackColor] setFill];
    
    // The shadow will move 4 pooints to the right and 3 points down from the text
    CGSize offset = CGSizeMake(4, 3);
    
    // The shadow will be dark grayColor
    CGColorRef color = [[UIColor darkGrayColor] CGColor];
    
    // Set the shadow of the context with these parameters,
    // all subsequent drawing will be shadowed
    CGContextSetShadowWithColor(ctx, offset, 2.0, color);
    
    // Draw the string
    [text drawInRect:textRect withAttributes:@{NSFontAttributeName : font}];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"Device started shaking!");
    if(motion == UIEventSubtypeMotionShake) {
        [self setCircleColor:[UIColor redColor]];
        [self setNeedsDisplay];        
    }
}

@end
