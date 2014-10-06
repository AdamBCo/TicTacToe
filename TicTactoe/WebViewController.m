//
//  WebViewController.m
//  TicTacToe
//
//  Created by Adam Cooper on 10/4/14.
//  Copyright (c) 2014 Adam Cooper. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadPage:@"https://en.wikipedia.org/wiki/Tic-tac-toe"];
    
}

- (void) loadPage: (NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
    NSLog(@"Website Loaded");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSString *urlTitleString = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navigationItem.title = urlTitleString;
}

@end
