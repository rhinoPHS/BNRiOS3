//
//  BNRItem.h
//  RandomPossessions
//
//  Created by joeconway on 7/19/11.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BNRItem : NSObject <NSCoding, NSSecureCoding>

+ (instancetype)randomItem;

- (instancetype)initWithItemName:(NSString *)name
        valueInDollars:(int)value
          serialNumber:(NSString *)sNumber;

@property (nonatomic, strong) BNRItem *containedItem;
@property (nonatomic, weak) BNRItem *container;

@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *serialNumber;
@property (nonatomic) int valueInDollars;
@property (nonatomic, strong) NSDate *dateCreated;

@property (nonatomic, copy) NSString *imageKey;

@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic, strong) NSData *thumbnailData;
-(void)setThumbnailDataFromImage:(UIImage *)image;
@end
