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
#import "NBNDeletionHelper.h"

@interface NBNHomeScreenViewController ()

@property (nonatomic, strong) NSArray *menuArray;
@property (nonatomic, strong) NSArray *domainArray;

@end

@implementation NBNHomeScreenViewController
@synthesize menuArray;
@synthesize domainArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.menuArray = @[NSLocalizedString(@"Favorites", nil), NSLocalizedString(@"Dashboard", nil), NSLocalizedString(@"Find Repos", nil)];
    }
    return self;
}

-(void)createLogoutButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setTitle:NSLocalizedString(@"Logout", nil) forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.f]];
	[button setTitleColor:[UIColor colorWithWhite:1.f alpha:1.f] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, 58.f, 27.f)];
    [button addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"BarButtonPlain.png"] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.domainArray = [Domain MR_findAll];
    [self.tableView reloadData];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"NavBar_home.png"];
    [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    [self createLogoutButton];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfWithCompletion:nil];
    
    if ([self.domainArray count] == 0) { // show login screen
        
        [self logout:nil];
        
    } else{
        Domain *domain = [self.domainArray lastObject];
        
        if ([domain.domain isEqualToString:@""] || [domain.password isEqualToString:@""] || [domain.email isEqualToString:@""]) {
            [self logout:nil];
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    UIImage *backgroundImage = [UIImage imageNamed:@"navBar.png"];
    [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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
    
    [NBNDeletionHelper deletePersistedData];
    
    [self presentViewController:navController animated:YES completion:nil];
    
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section == 0) { //static
        
        if (indexPath.row == 0) { //favorites
            NBNFavoritesViewController *favorites = [[NBNFavoritesViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:favorites animated:YES];
            
        } else if (indexPath.row == 1){ // Find Repos
            NBNDashboardViewController *dashboard = [[NBNDashboardViewController alloc] initWithNibName:@"NBNDashboardViewController" bundle:nil];
            [self.navigationController pushViewController:dashboard animated:YES];
            
        } else if (indexPath.row == 2){ // Find Repos
            NBNFindReposViewController *findRepos = [[NBNFindReposViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:findRepos animated:YES];

        }
        
    } else if (indexPath.section == 1){
        NBNProjectsViewController *projects = [[NBNProjectsViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:projects animated:YES];
        
    }
}

-(void)dealloc{
    
    PBLog(@"deallocing %@", [self class]);
}

@end
