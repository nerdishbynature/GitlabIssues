//
//  NBNHomeScreenViewController.m
//  GitLabIssues
//
//  Created by Piet Brauer on 16.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import "NBNHomeScreenViewController.h"
#import "NBNFavoritesViewController.h"
#import "NBNProjectsViewController.h"
#import "NBNFindReposViewController.h"
#import "NBNDashboardViewController.h"
#import "GLLoginViewController.h"
#import "Domain.h"

@interface NBNHomeScreenViewController ()

@property (nonatomic, retain) NSArray *menuArray;
@property (nonatomic, retain) NSArray *domainArray;

@end

@implementation NBNHomeScreenViewController
@synthesize menuArray;
@synthesize domainArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"GitLab:Issues";
        self.menuArray = @[@"Favorites", @"Dashboard", @"Find Repos"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setTitle:@"Logout" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.f]];
	[button setTitleColor:[UIColor colorWithWhite:1.f alpha:1.f] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, 58.f, 27.f)];
    [button addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"BarButtonPlain.png"] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.domainArray = [Domain findAll];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.domainArray = [Domain findAll];
    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[NSManagedObjectContext MR_defaultContext] saveNestedContexts];
    
    if ([self.domainArray count] == 0) { // show login screen
        
        [self logout:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return self.menuArray.count;
            break;

        case 1:
            return self.domainArray.count;
            break;
            
        default:
            return 1;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = [self.menuArray objectAtIndex:indexPath.row];
    } else{
        Domain *domain = (Domain*)[self.domainArray objectAtIndex:indexPath.row];
        cell.textLabel.text = domain.domain;
    }

    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
                             
#pragma mark - IBActions
                             
-(void)logout:(id)sender{
    GLLoginViewController *loginViewController = [[GLLoginViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    
    [self presentViewController:navController animated:YES completion:nil];
    
    [loginViewController release];
    [navController release];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section == 0) { //static
        
        if (indexPath.row == 0) { //favorites
            NBNFavoritesViewController *favorites = [[NBNFavoritesViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:favorites animated:YES];
            
            [favorites release];
        } else if (indexPath.row == 1){ // Find Repos
            NBNDashboardViewController *dashboard = [[NBNDashboardViewController alloc] initWithNibName:@"NBNDashboardViewController" bundle:nil];
            [self.navigationController pushViewController:dashboard animated:YES];
            
            [dashboard release];
        } else if (indexPath.row == 2){ // Find Repos
            NBNFindReposViewController *findRepos = [[NBNFindReposViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:findRepos animated:YES];

            [findRepos release];
        }
        
    } else if (indexPath.section == 1){
        NBNProjectsViewController *projects = [[NBNProjectsViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:projects animated:YES];
        
        [projects release];
    }
}

-(void)dealloc{
    self.menuArray = nil;
    self.domainArray = nil;
    
    [menuArray release];
    [domainArray release];
    PBLog(@"deallocing %@", [self class]);
    [super dealloc];
}

@end
