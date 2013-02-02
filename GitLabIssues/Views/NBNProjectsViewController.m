//
//  NBNProjectsViewController.m
//  GitLabIssues
//
//  Created by Piet Brauer on 16.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import "NBNProjectsViewController.h"
#import "Project.h"
#import "NBNProjectConnection.h"
#import "NBNIssuesViewController.h"
#import "MBProgressHUD.h"
#import "NBNBackButtonHelper.h"

@interface NBNProjectsViewController ()

@property (nonatomic, retain) NSArray *projectsArray;
@property (nonatomic, retain) MBProgressHUD *HUD;
@property (nonatomic, retain) NSArray *projectsSearchResults;
@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) UISearchDisplayController *searchDisplayController;

@end

@implementation NBNProjectsViewController
@synthesize projectsArray;
@synthesize HUD;
@synthesize projectsSearchResults;
@synthesize searchBar;
@synthesize searchDisplayController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"Projects";
        [self refreshDataSource];
        [self createSearchBar];
    }
    return self;
}

- (void)createSearchBar {
    
    if (self.tableView && !self.tableView.tableHeaderView) {
        self.searchBar = [[[UISearchBar alloc] init] autorelease];
        self.searchDisplayController = [[[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self] autorelease];
        self.searchDisplayController.searchResultsDelegate = self;
        self.searchDisplayController.searchResultsDataSource = self;
        self.searchDisplayController.delegate = self;
        searchBar.frame = CGRectMake(0, 0, 0, 38);
        self.tableView.tableHeaderView = self.searchBar;
    }
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [NBNBackButtonHelper setCustomBackButtonForViewController:self andNavigationItem:self.navigationItem];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.view addSubview:HUD];
    
    [self.navigationController setToolbarHidden:YES animated:YES];
	
	// Regiser for HUD callbacks so we can remove it from the window at the right time
	HUD.delegate = self;
	
	// Show the HUD while the provided method executes in a new thread
	[HUD show:YES];
    
    [[NBNProjectConnection sharedConnection] loadProjectsForDomain:[[Domain findAll] lastObject] onSuccess:^{
        [self refreshDataSource];
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NBNProjectConnection sharedConnection] cancelProjectsConnection];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView){
        return [self.projectsSearchResults count];
    } else{
        return self.projectsArray.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    Project *project;
    
    if (tableView == self.searchDisplayController.searchResultsTableView){
        project = [self.projectsSearchResults objectAtIndex:indexPath.row];
    } else{
        project = [self.projectsArray objectAtIndex:indexPath.row]; 
    }
    
    cell.textLabel.text = project.name;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.view addSubview:HUD];
	
	// Regiser for HUD callbacks so we can remove it from the window at the right time
	HUD.delegate = self;
	
	// Show the HUD while the provided method executes in a new thread
    Project *project;
    if (tableView == self.searchDisplayController.searchResultsTableView){
        project = [self.projectsSearchResults objectAtIndex:indexPath.row];
    } else{
        project = [self.projectsArray objectAtIndex:indexPath.row];
    }
    
    [HUD show:YES];
    [self navigateToIssues:project];
}

-(void)navigateToIssues:(Project *)project{
    [HUD hide:YES];
    [HUD removeFromSuperview];
    
    NBNIssuesViewController *issues = [NBNIssuesViewController loadWithProject:project];
    [self.navigationController pushViewController:issues animated:YES];
}

-(void)refreshDataSource{
    self.projectsArray = [[[[NSManagedObjectContext MR_defaultContext] ofType:@"Project"] orderByDescending:@"identifier"] toArray];
    [self.tableView reloadData];
    [self.HUD setHidden:YES];
    [self.HUD removeFromSuperview];
}

- (void)pushBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Search

#pragma mark - Searching

-(void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope{
    self.projectsSearchResults = [[[[NSManagedObjectContext MR_defaultContext] ofType:@"Project"] where:@"name contains[cd] %@",searchText] toArray];
    PBLog(@"filtering %@ got %i results %@", searchText, self.projectsSearchResults.count, self.projectsSearchResults);
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [self filterContentForSearchText:searchString scope:nil];
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:nil];
    return YES;
}

-(void)dealloc{
    self.projectsArray = nil;
    self.HUD = nil;
    self.projectsSearchResults = nil;
    self.searchBar = nil;
    self.searchDisplayController = nil;
    
    [projectsArray release];
    [HUD release];
    [projectsSearchResults release];
    [searchBar release];
    [searchDisplayController release];
    
    PBLog(@"deallocing %@", [self class]);
    [super dealloc];
}


@end
