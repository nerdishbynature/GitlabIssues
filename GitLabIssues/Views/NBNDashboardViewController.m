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
#import "NBNBackButtonHelper.h"
#import "NBNTabBarItem.h"

@interface NBNDashboardViewController ()

@property (nonatomic, retain) UIButton *createdButton;
@property (nonatomic, retain) UIButton *assignedButton;

@end

@implementation NBNDashboardViewController
@synthesize createdButton;
@synthesize assignedButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NBNAssignedToMeViewController *assignedViewController = [[NBNAssignedToMeViewController alloc] initWithStyle:UITableViewStylePlain];
        assignedViewController.tabBarItem = [[NBNTabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"tab_selected_03.png"] selectedImage:[UIImage imageNamed:@"tab_unselected_03.png"] tag:0];
        
        NBNCreatedByMeViewController *createdViewController = [[NBNCreatedByMeViewController alloc] initWithStyle:UITableViewStylePlain];
        createdViewController.tabBarItem = [[NBNTabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"tab_selected_02.png"] selectedImage:[UIImage imageNamed:@"tab_unselected_02.png"] tag:0];
        
        self.viewControllers = @[createdViewController, assignedViewController];
        
        [Flurry logAllPageViews:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [NBNBackButtonHelper setCustomBackButtonForViewController:self andNavigationItem:self.navigationItem];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hideTabBar];
	[self setupTabItems];
    //[self selectCreated];
}

-(void)setupTabItems{

    [self setupCreatedController];
    [self setupAssignedController];
}

-(void)setupCreatedController{
        
    UIImage *unselectedImage = [UIImage imageNamed:@"tab_unselected_02.png"];
    
    self.createdButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.createdButton setFrame:CGRectMake(0.f, [[UIScreen mainScreen] bounds].size.height-20.f-44.f-unselectedImage.size.height, unselectedImage.size.width, unselectedImage.size.height)];
    [self.createdButton setImage:unselectedImage forState:UIControlStateNormal];

    [self.createdButton addTarget:self action:@selector(selectCreated) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.createdButton];
}

-(void)setupAssignedController{
    
    UIImage *unselectedImage = [UIImage imageNamed:@"tab_unselected_03.png"];
    
    self.assignedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.assignedButton setFrame:CGRectMake(self.createdButton.frame.size.width, [[UIScreen mainScreen] bounds].size.height-20.f-44.f-unselectedImage.size.height, unselectedImage.size.width, unselectedImage.size.height)];
    
    [self.assignedButton setImage:unselectedImage forState:UIControlStateNormal];
    
    [self.assignedButton addTarget:self action:@selector(selectAssigned) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.assignedButton];
}

-(void)selectAssigned{
    [self.createdButton setSelected:NO];
    [self.assignedButton setSelected:YES];
    self.selectedIndex = 1;
}

-(void)selectCreated{
    self.assignedButton.selected = NO;
    self.createdButton.selected = YES;
    self.selectedIndex = 0;
}

- (void)hideTabBar
{
	for(UIView *view in self.view.subviews)
	{
		if([view isKindOfClass:[UITabBar class]])
		{
			view.hidden = YES;
		}
	}
}

- (void)pushBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    self.assignedButton = nil;
    self.createdButton = nil;
    
    [assignedButton release];
    [createdButton release];
    [super dealloc];
}

@end
