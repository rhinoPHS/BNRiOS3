//
//  BNRFeedActor.m
//  Nerdfeed
//
//  Created by rhino Q on 06/10/2019.
//  Copyright © 2019 rhino Q. All rights reserved.
//

#import "BNRFeedActor.h"

@implementation BNRFeedActor

- (instancetype)initWIthNSURL:(NSURL *)url {
    self = [super init];
    if(self) {
        self.url = url;
    }
    return self;
    
}

- (void)start {
    if(!sharedConnectionList)
        sharedConnectionList = [NSMutableArray array];
    [sharedConnectionList addObject:self];
    
    _xmlData = [NSMutableData new];
    __weak BNRFeedActor *weakSelf = self;
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    
    __block id rootObject = nil;
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:weakSelf.url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(data) {
            [weakSelf.xmlData appendData:data];
            NSString *xmlCheck = [[NSString alloc] initWithData:weakSelf.xmlData encoding:NSUTF8StringEncoding];
            NSLog(@"xmlCheck = %@", xmlCheck);
            
            if(weakSelf.xmlRootObject) {
                rootObject = weakSelf.xmlRootObject;
                
                NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
                [parser setDelegate:weakSelf.xmlRootObject];
                [parser parse];
            
            } else if (weakSelf.jsonRootObject) {
                //Trun JSON data into basic model objects
                NSDictionary *d = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                // Have the root object construct itself from basic model objects
                [weakSelf.jsonRootObject readFromJSONDictionary:d];
                rootObject = weakSelf.jsonRootObject;
            }
            
            if(self.completionBlock) {
                weakSelf.completionBlock(rootObject,nil);
            }
            
            data = nil;
            [sharedConnectionList removeObject:self];
            
        } else {
            weakSelf.completionBlock(nil,error);
        }
    }];
    [task resume];

}

@end
