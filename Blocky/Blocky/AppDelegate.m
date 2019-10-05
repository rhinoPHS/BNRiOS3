//
//  AppDelegate.m
//  Blocky
//
//  Created by rhino Q on 05/10/2019.
//  Copyright © 2019 rhino Q. All rights reserved.
//

#import "AppDelegate.h"
#import "BNRExecutor.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    int (^adder)(int, int) = ^int(int x, int y) {
//        return x+y;
//    };
    //    [executor setEquation:adder];
    
    BNRExecutor *executor = [[BNRExecutor alloc] init];
    
    int multiplier = 3;
    
    [executor setEquation:^int(int x, int y) {
        int sum = x + 2;
        return multiplier * (sum + y);
//        return x+y;
    }];
    
    multiplier = 100;
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSLog(@"%d",[executor computeWithValue:2 andValue:5]);
    }];
    
    NSLog(@"About to exit method...");
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
