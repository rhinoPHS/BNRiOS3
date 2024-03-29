//
//  WebViewController.h
//  Nerdfeed
//
//  Created by rhino Q on 04/10/2019.
//  Copyright © 2019 rhino Q. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WebViewController : UIViewController<ViewControllerDelegate, UISplitViewControllerDelegate>

@property (nonatomic, readonly) WKWebView *webView;

@end
NS_ASSUME_NONNULL_END
