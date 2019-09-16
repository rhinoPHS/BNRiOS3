//
//  BNRItem.h
//  RandomPossessions
//
//  Created by rhino Q on 16/08/2019.
//  Copyright © 2019 rhino Q. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BNRItem : NSObject

@property (nonatomic, strong) BNRItem *containedItem;
@property (nonatomic, weak) BNRItem *container;

@property (copy, nonatomic) NSString *itemName;
@property (copy, nonatomic) NSString *serialNumber;
@property int valueInDollars;
@property (nonatomic, readonly, strong) NSDate *dateCreated;

+(instancetype)randomItem;

-(instancetype)initWithItemName:(NSString *)name
                 valueInDollars:(int)value
                   serialNumber:(NSString *)number;

@end

NS_ASSUME_NONNULL_END
