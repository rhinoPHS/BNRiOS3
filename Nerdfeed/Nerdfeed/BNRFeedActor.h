//
//  BNRFeedActor.h
//  Nerdfeed
//
//  Created by rhino Q on 06/10/2019.
//  Copyright © 2019 rhino Q. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"

NS_ASSUME_NONNULL_BEGIN

static NSMutableArray *sharedConnectionList = nil;

@interface BNRFeedActor : NSObject

@property (nonatomic)  NSMutableData *xmlData;

-(instancetype)initWIthNSURL:(NSURL*)url;

@property (nonatomic, copy) NSURL *url;
@property (nonatomic, copy) void(^completionBlock)(id _Nullable obj, NSError * _Nullable err);
@property (nonatomic, strong) id <NSXMLParserDelegate> xmlRootObject;
@property (nonatomic, strong) id <JSONSerializable> jsonRootObject;

-(void)start;

@end

NS_ASSUME_NONNULL_END
