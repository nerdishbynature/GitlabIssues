//
//  NBNAppDelegate.m
//  GitLabIssues
//
//  Created by Piet Brauer on 16.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import "NBNAppDelegate.h"
#import "NBNHomeScreenViewController.h"
#import "Domain.h"
#import "Session.h"

@implementation NBNAppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"GitLabIssues.sqlite"];
    
    UIImage *image = [UIImage imageNamed:@"navBar.png"];
    [[UINavigationBar appearance] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    [[UIToolbar appearance] setBackgroundImage:image forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    [[UITableView appearance] setBackgroundView:nil];
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:64.f/255.f green:64.f/255.f blue:64.f/255.f alpha:1.0f]];
    [[UISearchBar appearance] setBackgroundImage:image];
    
    NBNHomeScreenViewController *homeScreen = [[NBNHomeScreenViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:homeScreen];
    
    NSArray *sessionArray = [Session findAll];
    
    for (Session *session in sessionArray) {
        PBLog(@"deleting %@", session.private_token);
        [[NSManagedObjectContext MR_contextForCurrentThread] deleteObject:session];
    }
    
    PBLog(@"sessions %@", [Session findAll]);
    
    self.window.rootViewController = navController;
    
    [navController release];
    [homeScreen release];

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [[NSManagedObjectContext MR_contextForCurrentThread] saveNestedContexts];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSArray *sessionArray = [Session findAll];
    
    for (Session *session in sessionArray) {
        PBLog(@"deleting %@", session.private_token);
        [[NSManagedObjectContext MR_contextForCurrentThread] deleteObject:session];
    }
    
    PBLog(@"sessions %@", [Session findAll]);
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
