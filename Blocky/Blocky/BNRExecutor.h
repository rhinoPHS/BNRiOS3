//
//  BNRExecutor.h
//  Blocky
//
//  Created by rhino Q on 05/10/2019.
//  Copyright © 2019 rhino Q. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BNRExecutor : NSObject

@property (nonatomic, copy)int (^equation)(int,int);
-(int)computeWithValue:(int)value1 andValue:(int)value2;

@end

NS_ASSUME_NONNULL_END
