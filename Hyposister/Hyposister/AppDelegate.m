//
//  AppDelegate.m
//  Hyposister
//
//  Created by rhino Q on 21/09/2019.
//  Copyright © 2019 rhino Q. All rights reserved.
//

#import "AppDelegate.h"
#import "HypnosisView.h"
#import "ViewController.h"
#import <UIKit/UIKit.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    ViewController *vc = [[ViewController alloc] init];
    [self.window setRootViewController:vc];
    
//    CGRect viewFrame = CGRectMake(160, 240, 100, 150);
//    HypnosisView *view = [[HypnosisView alloc] initWithFrame:viewFrame];
//    [view setBackgroundColor:[UIColor redColor]];
//    [[self window] addSubview:view];
    
//    CGRect anotherFrame = CGRectMake(20, 30, 50, 50);
//    HypnosisView *anotherView = [[HypnosisView alloc] initWithFrame:anotherFrame];
//    [anotherView setBackgroundColor:[UIColor blueColor]];
//    [[self window] addSubview:anotherView];
//    [view addSubview:anotherView];
    
    CGRect screenRect = [[self window] bounds];
    
    //Create the UIScrollView to have the size of the window, matching its size
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:screenRect];
//    [[self window] addSubview:scrollView];
    [scrollView setPagingEnabled:NO];
    [scrollView setMinimumZoomScale:1.0];
    [scrollView setMaximumZoomScale:5.0];
    [scrollView setDelegate:self];
    [vc.view addSubview:scrollView];
    
    
//    HypnosisView *view = [[HypnosisView alloc] initWithFrame:[[self window] bounds]];
//    [[self window] addSubview:view];
    
    // Create the HypnosisView with a frame that is twice the size of the screen
    CGRect bigRect = screenRect;
//    bigRect.size.width *= 2.0;
//    bigRect.size.height *= 2.0;
    //HypnosisView *view = [[HypnosisView alloc] initWithFrame:screenRect];
    view = [[HypnosisView alloc] initWithFrame:screenRect];
    [scrollView addSubview:view];
    
    //Move the rectangle for the other HypnosisView to the right, just off the screen
//    screenRect.origin.x = screenRect.size.width;
//    HypnosisView *anotherView = [[HypnosisView alloc] initWithFrame:screenRect];
//    [scrollView addSubview:anotherView];
    
    //Tell the scrollView how big its virtual world is
    [scrollView setContentSize:bigRect.size];
    
    BOOL success = [view becomeFirstResponder];
    if(success) {
        NSLog(@"HyposisView became the first responder");
    } else {
        NSLog(@"Couldd not become first responder");
    }
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return view;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
