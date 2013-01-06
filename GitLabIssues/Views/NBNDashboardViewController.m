//
//  NBNDashboardViewController.m
//  GitLabIssues
//
//  Created by Piet Brauer on 30.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import "NBNDashboardViewController.h"
#import "NBNCreatedByMeViewController.h"
#import "NBNAssignedToMeViewController.h"

@interface NBNDashboardViewController ()

@end

@implementation NBNDashboardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NBNAssignedToMeViewController *assignedViewController = [[NBNAssignedToMeViewController alloc] initWithStyle:UITableViewStylePlain];
        assignedViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Assigned" image:nil tag:0];
        
        NBNCreatedByMeViewController *createdViewController = [[NBNCreatedByMeViewController alloc] initWithStyle:UITableViewStylePlain];
        createdViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Created" image:nil tag:1];
        
        self.viewControllers = @[createdViewController, assignedViewController];
        
        [createdViewController release];
        [assignedViewController release];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end