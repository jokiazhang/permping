//
//  AppDelegate.m
//  Permping
//
//  Created by MAC on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "UINavigationBar+CustomBackground.h"
#import "FollowingViewController.h"
#import "ExplorerViewController.h"
#import "ImageViewController.h"
#import "MyDiaryViewController.h"
#import "ProfileViewController.h"


@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [super dealloc];
}

- (UINavigationController*)navigationControllerWithRootController:(UIViewController*)viewController {
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    return [navController autorelease];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    // Override point for customization after application launch.
    FollowingViewController *viewController1 = [[[FollowingViewController alloc] initWithNibName:@"FollowingViewController" bundle:nil] autorelease];
    ExplorerViewController *viewController2 = [[[ExplorerViewController alloc] initWithNibName:@"ExplorerViewController" bundle:nil] autorelease];
    ImageViewController *viewController3 = [[[ImageViewController alloc] initWithNibName:@"ImageViewController" bundle:nil] autorelease];
    MyDiaryViewController *viewController4 = [[[MyDiaryViewController alloc] initWithNibName:@"MyDiaryViewController" bundle:nil] autorelease];
    ProfileViewController *viewController5 = [[[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil] autorelease];
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:[self navigationControllerWithRootController:viewController1], [self navigationControllerWithRootController:viewController2], [self navigationControllerWithRootController:viewController3], [self navigationControllerWithRootController:viewController4], [self navigationControllerWithRootController:viewController5], nil];
    self.tabBarController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"default-background.png"]];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
