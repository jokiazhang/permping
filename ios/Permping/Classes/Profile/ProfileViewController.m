//
//  ProfileViewController.m
//  Permping
//
//  Created by MAC on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProfileViewController.h"
#import "UserProfileView.h"

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"ProfileTabTitle", @"Profile");
        self.tabBarItem.image = [UIImage imageNamed:@"tab-item-profile"];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    UserProfileView *profileView = [[[UserProfileView alloc] initWithFrame:self.view.bounds] autorelease];
    [self.view addSubview:profileView];
    
    //phong remove
//    self.user = [[WSUser alloc] initWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"Steve Raquel", @"userName", @"user01", @"userId", @"http://farm8.static.flickr.com/7123/7134938811_c22914bd39_s.jpg", @"userAvatar", nil]];
//    profileView.user = self.user;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


@end
