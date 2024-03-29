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
#import "AppData.h"
#import "Utility.h"
#import "Constants.h"

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
    [[AppData getInstance] restoreState];
    // Override point for customization after application launch.
    FollowingViewController *viewController1 = [[[FollowingViewController alloc] initWithNibName:@"FollowingViewController" bundle:nil] autorelease];
    ExplorerViewController *viewController2 = [[[ExplorerViewController alloc] initWithNibName:@"ExplorerViewController" bundle:nil] autorelease];
    ImageViewController *viewController3 = [[[ImageViewController alloc] initWithNibName:@"ImageViewController" bundle:nil] autorelease];
    MyDiaryViewController *viewController4 = [[[MyDiaryViewController alloc] initWithNibName:@"MyDiaryViewController" bundle:nil] autorelease];
    ProfileViewController *viewController5 = [[[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil] autorelease];
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:[self navigationControllerWithRootController:viewController1], [self navigationControllerWithRootController:viewController2], [self navigationControllerWithRootController:viewController3], [self navigationControllerWithRootController:viewController4], [self navigationControllerWithRootController:viewController5], nil];
    self.tabBarController.view.backgroundColor = [Utility colorRefWithString:@"#f2f2f2"];// [UIColor colorWithPatternImage:[UIImage imageNamed:@"default-background.png"]];
    self.tabBarController.delegate = self;
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{   
    NSLog(@"url: %@", url);
    if (!url) {
        return NO;
    }
    NSString *urlString = [url absoluteString];
    if ([urlString hasPrefix:LAUNCH_APP_URL]) {
        NSRange range = [urlString rangeOfString:LAUNCH_APP_URL];
        NSString *strParameters = [urlString substringFromIndex:range.location+range.length];
        NSArray *params = [strParameters componentsSeparatedByString:@"/"];
        if ([params count] > 0) {
            NSMutableDictionary *openInfo = [[NSMutableDictionary alloc] init];
            for (NSInteger i=0; i<[params count]-1; i+=2) {
                NSString *key = [params objectAtIndex:i];
                NSString *value = [params objectAtIndex:i+1];
                [openInfo setValue:value forKey:key];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kApplicationHandleOpenURLNotification object:self userInfo:openInfo];
            [openInfo release];
        }
    }
    
    return YES;
}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController 
{
    if ([tabBarController selectedIndex] == 4) {
        if (( [[tabBarController viewControllers] objectAtIndex:4] == viewController) &&
            ![[AppData getInstance] didLogin]) {
            return NO;
        }
    }
    
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
    [[AppData getInstance] saveState];
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
    // Dispatch notification to controllers
    [[NSNotificationCenter defaultCenter] postNotificationName: kApplicationDidBecomeActiveNotification 
                                                        object: nil 
                                                      userInfo: nil];
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
