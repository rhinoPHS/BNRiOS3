//
//  RSSChannel.h
//  Nerdfeed
//
//  Created by rhino Q on 04/10/2019.
//  Copyright © 2019 rhino Q. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"

NS_ASSUME_NONNULL_BEGIN

@interface RSSChannel : NSObject <NSXMLParserDelegate, JSONSerializable, NSCoding, NSSecureCoding, NSCopying>

@property (nonatomic, weak) id parentParserDelegate;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *infoString;
@property (nonatomic, readonly, strong) NSMutableArray *items;
@property (nonatomic, copy) NSMutableString *currentString;

-(void)addItemsFromChannel:(RSSChannel *)otherChannel;

@end


NS_ASSUME_NONNULL_END
