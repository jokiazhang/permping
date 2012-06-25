//
//  PermUrlViewController.m
//  Permping
//
//  Created by MAC on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PermUrlViewController.h"
#import "Utils.h"

@implementation PermUrlViewController
@synthesize urlString;

- (void)dealloc {
    permUrlWebView.delegate = nil;
    [permUrlWebView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [Utils barButtonnItemWithTitle:NSLocalizedString(@"globals.back", @"Back") target:self selector:@selector(dismissAndCancelLoadPermUrl)];
    
    permUrlWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    permUrlWebView.scalesPageToFit = YES;
    permUrlWebView.delegate = self;
    [self.view addSubview:permUrlWebView];
    if (urlString) {
        [self startActivityIndicator];
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [permUrlWebView loadRequest:request];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self stopActivityIndicator];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self stopActivityIndicator];
}

- (void)dismissAndCancelLoadPermUrl {
    if (permUrlWebView.loading) {
        [permUrlWebView stopLoading];
        [self stopActivityIndicator];
    }
    [super dismiss:nil];
}

- (void)logoutDidFinish:(NSNotification*)notification {
    // Do nothing
}

@end
