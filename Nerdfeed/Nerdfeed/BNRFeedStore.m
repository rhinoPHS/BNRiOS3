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

@implementation BNRFeedStore

+ (BNRFeedStore *)sharedStore {
    static BNRFeedStore *feedStore = nil;
    if(!feedStore)
        feedStore = [[BNRFeedStore alloc] init];
    
    return feedStore;
}


- (void)fetchRSSFeedWithCompletion:(void (^)(RSSChannel * _Nonnull obj, NSError * _Nonnull err))block {
    NSURL *url = [NSURL URLWithString:@"https://www.cocoawithlove.com/feed.xml"];
    
    RSSChannel *channel = [RSSChannel new];
    
    // Create a connection "actor" object that will transfer data from the server
    BNRFeedActor *actor = [[BNRFeedActor alloc] initWIthNSURL:url];
    
    // When the connection completes, this block from the controller will be called
    [actor setCompletionBlock:block];
    
    // let the empty channel parse the returning data from the web service
    [actor setXmlRootObject:channel];
    
    //Begin the connection
    [actor start];
    
}

- (void)fetchTopSongs:(int)count withCompletioon:(void (^)(RSSChannel * _Nonnull, NSError * _Nonnull))block {
    // Prepare a request URL, including the argument from the controller
    NSString *requestString = [NSString stringWithFormat:@"http://itunes.apple.com/us/rss/topsongs/limit=%d/json", count];
    NSURL *url = [NSURL URLWithString:requestString];
    
    RSSChannel *channel = [RSSChannel new];
    
    // Create a connection "actor" object that will transfer data from the server
    BNRFeedActor *actor = [[BNRFeedActor alloc] initWIthNSURL:url];
    
    // When the connection completes, this block from the controller will be called
    [actor setCompletionBlock:block];
    
    // let the empty channel parse the returning data from the web service
    [actor setJsonRootObject:channel];
    
    //Begin the connection
    [actor start];
}

@end
