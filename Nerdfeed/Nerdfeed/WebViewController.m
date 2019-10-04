//
//  WebViewController.m
//  Nerdfeed
//
//  Created by rhino Q on 04/10/2019.
//  Copyright © 2019 rhino Q. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <WKNavigationDelegate>
@property (nonatomic, strong) UIBarButtonItem *backBtn;
@property (nonatomic, strong) UIBarButtonItem *goBtn;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.webView addObserver:self forKeyPath:@"URL" options:NSKeyValueObservingOptionNew context:NULL];
    
    [self addToolbar];
//    [self enableToolBarButtons];
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    if([keyPath isEqualToString:@"URL"]){
//        NSLog(@"page has changed");
//        [self enableToolBarButtons];
//    } else {
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//    }
//}

-(void)addToolbar {
    self.navigationController.toolbarHidden = NO;
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    _backBtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    _goBtn = [[UIBarButtonItem alloc] initWithTitle:@"Go" style:UIBarButtonItemStylePlain target:self action:@selector(goForward)];
    NSArray *items = [NSArray arrayWithObjects:_backBtn, _goBtn, flexibleItem, nil];
    self.toolbarItems = items;
}

-(void)enableToolBarButtons {
    _backBtn.enabled = self.webView.canGoBack;
    _goBtn.enabled = self.webView.canGoForward;
}

-(void)goBack {
    if(self.webView.canGoBack) {
        [self.webView goBack];
    }
}

-(void)goForward {
    if(self.webView.canGoForward) {
        [self.webView goForward];
    }
}

- (void)loadView {
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    WKWebView *wv = [[WKWebView alloc] initWithFrame:screenFrame];
    [self setView:wv];
}

- (WKWebView *)webView {
    return (WKWebView *)[self view];
}

@end
