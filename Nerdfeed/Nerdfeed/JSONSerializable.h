//
//  JSONSerializable.h
//  Nerdfeed
//
//  Created by rhino Q on 07/10/2019.
//  Copyright © 2019 rhino Q. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JSONSerializable <NSObject>

-(void)readFromJSONDictionary:(NSDictionary *)d;

@end

NS_ASSUME_NONNULL_END
