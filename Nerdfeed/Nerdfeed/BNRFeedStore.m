//
//  BNRFeedStore.m
//  Nerdfeed
//
//  Created by rhino Q on 06/10/2019.
//  Copyright © 2019 rhino Q. All rights reserved.
//

#import "BNRFeedStore.h"
#import "BNRFeedActor.h"
#import "RSSChannel.h"
#import "RSSItem.h"

@implementation BNRFeedStore

+ (BNRFeedStore *)sharedStore {
    static BNRFeedStore *feedStore = nil;
    if(!feedStore)
        feedStore = [[BNRFeedStore alloc] init];
    
    return feedStore;
}


- (void)setTopSongsCacheDate:(NSDate *)topSongsCacheDate {
    [[NSUserDefaults standardUserDefaults] setObject:topSongsCacheDate forKey:@"topSongsCacheDate"];
}

- (NSDate *)topSongsCacheDate {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"topSongsCacheDate"];
}

- (RSSChannel *)fetchRSSFeedWithCompletion:(void (^)(RSSChannel * _Nullable obj, NSError * _Nullable err))block {
    NSURL *url = [NSURL URLWithString:@"https://www.cocoawithlove.com/feed.xml"];
    
    RSSChannel *channel = [RSSChannel new];
    
    // Create a connection "actor" object that will transfer data from the server
    BNRFeedActor *actor = [[BNRFeedActor alloc] initWIthNSURL:url];
    
    // When the connection completes, this block from the controller will be called
//    [actor setCompletionBlock:block];
    
    
    /// p.539
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    cachePath = [cachePath stringByAppendingPathComponent:@"nerd.archive"];
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:cachePath];
    NSSet *classes = [NSSet setWithArray:@[
        [NSMutableArray class],
        [RSSChannel class],
        [RSSItem class],
        [NSMutableString class]
    ]];
    
    NSError *error;
    RSSChannel *cachedChannel = [NSKeyedUnarchiver unarchivedObjectOfClasses:classes fromData:data error:&error];
    if(error) {
        NSLog(@"unarchive error in fetchRSSFeedWithCompletion : %@", error);
        block(nil,error);
        return nil;
    }
    
    if(!cachedChannel)
        cachedChannel = [RSSChannel new];
    
    RSSChannel *channelCopy = [cachedChannel copy];
    
    [actor setCompletionBlock:^(id  _Nullable obj, NSError * _Nullable err) {
        if(!err) {
            NSError *error;
            [channelCopy addItemsFromChannel:obj];
            NSData * data = [NSKeyedArchiver archivedDataWithRootObject:channelCopy requiringSecureCoding:NO error:&error];
            if(error) {
                block(nil,error);
                NSLog(@"archived error : %@", error);
                return;
            }
            if([data writeToFile:cachePath atomically:NO]) {
                NSLog(@"isWriteToFile success %@", cachePath);
            } else {
                NSLog(@"isWriteToFile fail %@", cachePath);
            }
            block(channelCopy, nil);
        } else {
            NSLog(@"archivedDataWithRootObject fail : %@", error);
            block(nil,error);
        }
    }];
    ///////////////
    
    
    // let the empty channel parse the returning data from the web service
    [actor setXmlRootObject:channel];
    
    //Begin the connection
    [actor start];
    
    return cachedChannel;
    
}

- (void)fetchTopSongs:(int)count withCompletioon:(void (^)(RSSChannel * _Nullable, NSError * _Nullable))block {
    
    // Construct the cache path
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    cachePath = [cachePath stringByAppendingPathComponent:@"apple.archive"];
    
    
    // Make sure we have cached at least once before by checking to see
    // if this date exists!
    NSDate *tscDate = [self topSongsCacheDate];
    if(tscDate) {
        // How old is the cache?
        NSTimeInterval cacheAge = [tscDate timeIntervalSinceNow];
        if(cacheAge > -300.0) {
            //If it is less than 3-- seconds (5 min) old, return cache in completion block
            NSLog(@"%f", cacheAge);
            NSLog(@"Reading cache!");
            
            NSData *data = [[NSData alloc] initWithContentsOfFile:cachePath];
            NSSet *classes = [NSSet setWithArray:@[
                [NSMutableArray class],
                [RSSChannel class],
                [RSSItem class]
            ]];
            
            NSError *error;
            RSSChannel *cachedChannel = [NSKeyedUnarchiver unarchivedObjectOfClasses:classes fromData:data error:&error];
            if(error) {
                NSLog(@"unarchive error : %@", error);
                block(nil,error);
                return;
            }
             
            if(cachedChannel) {
                // Execute the controller's completion block to reload its table
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    block(cachedChannel, nil);
                }];
                return;
            }
        }
    }
    
    
    
    
    // Prepare a request URL, including the argument from the controller
    NSString *requestString = [NSString stringWithFormat:@"http://itunes.apple.com/us/rss/topsongs/limit=%d/json", count];
    NSURL *url = [NSURL URLWithString:requestString];
    
    RSSChannel *channel = [RSSChannel new];
    
    // Create a connection "actor" object that will transfer data from the server
    BNRFeedActor *actor = [[BNRFeedActor alloc] initWIthNSURL:url];
    
    // When the connection completes, this block from the controller will be called
    
    //    [actor setCompletionBlock:block];
    [actor setCompletionBlock:^(id  _Nullable obj, NSError * _Nullable err) {
        // This is the store's completion code:
        // If everything wehnt smoothly, save the channel to disk and set cache date
        if (!err) {
            [self setTopSongsCacheDate:[NSDate date]];
            NSError *error;
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:obj requiringSecureCoding:NO error:&error];
            if(error) {
                block(nil,error);
                NSLog(@"archived error : %@", error);
                return;
            }
            
            if([data writeToFile:cachePath atomically:NO]) {
                NSLog(@"isWriteToFile success %@", cachePath);
            } else {
                NSLog(@"isWriteToFile fail %@", cachePath);
            }
            
            NSLog(@"data received from server");
            //This is the controller's completion code;
            block(obj,err);
            
        } else {
            block(nil,err);
            NSLog(@"BNRFeedStore err : %@", err);
            return;
        }
    }];
    
    // let the empty channel parse the returning data from the web service
    [actor setJsonRootObject:channel];
    
    //Begin the connection
    [actor start];
}

@end
