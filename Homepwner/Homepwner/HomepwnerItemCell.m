//
//  HomepwnerItemCell.m
//  Homepwner
//
//  Created by rhino Q on 16/09/2019.
//  Copyright © 2019 rhino Q. All rights reserved.
//

#import "HomepwnerItemCell.h"

@implementation HomepwnerItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)showImage:(id)sender {
    // Get this name of this method, "showImage:"
    NSString *selector = NSStringFromSelector(_cmd);
    // selector is now "showImage:atIndxPath:"
    selector = [selector stringByAppendingString:@"atIndexPath:"];
    
    // Prepare a selector from this string
    SEL newSelector = NSSelectorFromString(selector);
    
    NSIndexPath *indexPath = [[self tableView] indexPathForCell:self];
    
    if(indexPath) {
        if([[self controller] respondsToSelector:newSelector]) {
            //Ignore warning for this line - may or may not appear, doesn't matter
            //    [[[self controller] showImage:sender] atInexPath:indexPath];
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [[self controller] performSelector:newSelector
                                    withObject:sender
                                    withObject:indexPath];
            #pragma clang diagnostic pop
        }
    }
}
@end
