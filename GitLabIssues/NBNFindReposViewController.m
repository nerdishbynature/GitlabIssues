//
//  NBNFindReposViewController.m
//  GitLabIssues
//
//  Created by Piet Brauer on 17.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import "NBNFindReposViewController.h"
#import "NBNProjectConnection.h"
#import "Project.h"
#import "NBNIssuesViewController.h"
#import "MBProgressHUD.h"
#import "NBNBackButtonHelper.h"

@interface NBNFindReposViewController ()

@property (nonatomic, retain) NSArray *projectsArray;
@property (nonatomic, retain) UISearchDisplayController *searchDisplayController;
@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) NSArray *projectsSearchResults;
@property (nonatomic, retain) MBProgressHUD *HUD;

@end

@implementation NBNFindReposViewController
@synthesize projectsArray;
@synthesize searchDisplayController;
@synthesize searchBar;
@synthesize projectsSearchResults;
@synthesize HUD;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [self createSearchBar];
        self.title = @"Search";
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.HUD = [[[MBProgressHUD alloc] initWithView:self.navigationController.view] autorelease];
	[self.view addSubview:HUD];
    
	// Show the HUD while the provided method executes in a new thread
	[HUD show:YES];
    
    [[NBNProjectConnection sharedConnection] loadProjectsForDomain:[[Domain findAll] lastObject] onSuccess:^{
        self.projectsArray = [Project findAllSortedBy:@"identifier" ascending:YES];
        [self.tableView reloadData];
        [HUD setHidden:YES];
        [self.HUD removeFromSuperview];
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
    Project *project;
    if (tableView == self.searchDisplayController.searchResultsTableView){
        project = [self.projectsSearchResults objectAtIndex:indexPath.row];
    } else{
        project = [self.projectsArray objectAtIndex:indexPath.row];
    }
    
    NBNIssuesViewController *issues = [NBNIssuesViewController loadWithProject:project];
    [self.navigationController pushViewController:issues animated:YES];
}

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

- (void)pushBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc{
    self.projectsArray = nil;
    self.searchDisplayController = nil;
    self.searchBar = nil;
    self.projectsSearchResults = nil;
    self.HUD = nil;
    
    [projectsArray release];
    [searchDisplayController release];
    [searchBar release];
    [projectsSearchResults release];
    [HUD release];
    
    PBLog(@"deallocing %@", [self class]);
    [super dealloc];
}

@end
