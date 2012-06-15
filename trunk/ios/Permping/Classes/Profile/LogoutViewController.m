//
//  LogoutViewController.m
//  Permping
//
//  Created by Andrew Duck on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LogoutViewController.h"
#import "Utils.h"
#import "AppData.h"

@implementation LogoutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    
    
    self.navigationItem.leftBarButtonItem = [Utils barButtonnItemWithTitle:NSLocalizedString(@"globals.cancel", @"Cancel") target:self selector:@selector(dismissWithFlipAnimationTransition)];
    
    [logoutButton setBackgroundImage:[[UIImage imageNamed:@"btn-background.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:0] forState:UIControlStateNormal];
    
    [cancelButton setBackgroundImage:[[UIImage imageNamed:@"btn-background.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:0] forState:UIControlStateNormal];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (IBAction)logoutButtonDidTouch:(id)sender {
    [self startActivityIndicator];
    [[AppData getInstance] logout];
}

- (IBAction)cancelButtonDidTouch:(id)sender {
    [self dismissWithFlipAnimationTransition];
}

- (void)dismissWithFlipAnimationTransition {
    //[self.navigationController popViewControllerAnimationTransition:UIViewAnimationTransitionFlipFromLeft];
    [self dismiss:nil];
}

- (void)logoutDidFinish:(NSNotification*)notification {
    [self stopActivityIndicator];
    BOOL isSuccess = [[notification.userInfo objectForKey:@"isSuccess"] boolValue];
    if (isSuccess) {
        [self dismissWithFlipAnimationTransition];
    }
}

@end
