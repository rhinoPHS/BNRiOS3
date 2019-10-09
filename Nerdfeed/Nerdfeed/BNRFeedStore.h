//
//  BNRFeedStore.h
//  Nerdfeed
//
//  Created by rhino Q on 06/10/2019.
//  Copyright © 2019 rhino Q. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RSSChannel;

NS_ASSUME_NONNULL_BEGIN

@interface BNRFeedStore : NSObject

+ (BNRFeedStore *)sharedStore;
//@property (nonatomic)  NSMutableData *xmlData;
@property (nonatomic, strong) NSDate *topSongsCacheDate;
-(RSSChannel *)fetchRSSFeedWithCompletion:(void (^)(RSSChannel *obj, NSError *err))block;
-(void)fetchTopSongs:(int)count withCompletioon:(void (^)(RSSChannel *obj, NSError *err))block;

@end

NS_ASSUME_NONNULL_END
