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
    
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    cachePath = [cachePath stringByAppendingPathComponent:@"nerd.archive"];
    RSSChannel *cachedChannel = [self unarchiveWiPath:cachePath];
    
    if(!cachedChannel)
        cachedChannel = [RSSChannel new];
    
    RSSChannel *channelCopy = [cachedChannel copy];
    
    [actor setCompletionBlock:^(id  _Nullable obj, NSError * _Nullable err) {
        if(!err) {
            [channelCopy addItemsFromChannel:obj];
            [self archiveWith:channelCopy error:&err inPath:cachePath];
        }
        //This is the controller's completion code;
        block(channelCopy, err);
    }];

    // let the empty channel parse the returning data from the web service
    [actor setXmlRootObject:channel];
    
    //Begin the connection
    [actor start];
    
    return cachedChannel;
    
}

-(RSSChannel*)unarchiveWiPath:(NSString*)cachePath {
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
        NSLog(@"unarchive error in fetchRSSFeedWithCompletion : %@, path: %@", error,cachePath);
        return nil;
    } else {
        return cachedChannel;
    }
}

-(void)archiveWith:(id)rawData error:(NSError**)err inPath:(NSString*)cachePath {
    NSData * dataToArchive = [NSKeyedArchiver archivedDataWithRootObject:rawData requiringSecureCoding:NO error:err];
    [self writeToFile:cachePath withData:dataToArchive];
}


-(void)writeToFile:(NSString *)path withData:(NSData*)data{
    if([data writeToFile:path atomically:NO]) {
        NSLog(@"isWriteToFile success %@", path);
    } else {
        NSLog(@"isWriteToFile fail %@", path);
    }
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
            //If it is less than 300 seconds (5 min) old, return cache in completion block
            NSLog(@"%f", cacheAge);
            NSLog(@"Reading cache!");
            
            RSSChannel *cachedChannel = [self unarchiveWiPath:cachePath];
            if(cachedChannel) {
                // Execute the controller's completion block to reload its table
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    block(cachedChannel, nil);
                }];
                // Don't need to make the request, just get out of this method
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
    [actor setCompletionBlock:^(id  _Nullable obj, NSError * _Nullable err) {
        // This is the store's completion code:
        // If everything wehnt smoothly, save the channel to disk and set cache date
        if (!err) {
            [self setTopSongsCacheDate:[NSDate date]];
            [self archiveWith:obj error:&err inPath:cachePath];
        }
        //This is the controller's completion code;
        block(obj,err);
    }];
    
    // let the empty channel parse the returning data from the web service
    [actor setJsonRootObject:channel];
    
    //Begin the connection
    [actor start];
}

@end
