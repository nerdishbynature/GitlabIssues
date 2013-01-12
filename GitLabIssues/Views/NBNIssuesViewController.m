//
//  NBNIssuesViewController.m
//  GitLabIssues
//
//  Created by Piet Brauer on 16.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import "NBNIssuesViewController.h"
#import "Issue.h"
#import "Author.h"
#import "NBNIssuesConnection.h"
#import "NBNIssueDetailViewController.h"
#import "NBNIssueFilterViewController.h"
#import "NBNIssueEditViewController.h"
#import "NBNIssueCell.h"
#import "MBProgressHUD.h"

@interface NBNIssuesViewController ()

@property (nonatomic, retain) Project *project;
@property (nonatomic, retain) NSArray *issues;
@property (nonatomic, retain) UISearchDisplayController *searchDisplayController;
@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) NSArray *issuesSearchResults;
@property (nonatomic, retain) MBProgressHUD *HUD;

@end

@implementation NBNIssuesViewController
@synthesize project;
@synthesize issues;
@synthesize searchDisplayController;
@synthesize searchBar;
@synthesize issuesSearchResults;
@synthesize HUD;

+(NBNIssuesViewController *)loadWithProject:(Project *)_project{
    NBNIssuesViewController *issueViewController = [[[NBNIssuesViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
    issueViewController.project = _project;
    [issueViewController createSearchBar];
    return issueViewController;
}

- (void)createSearchBar {

    if (self.tableView && !self.tableView.tableHeaderView) {
        self.searchBar = [[UISearchBar alloc] init];
        self.searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        self.searchDisplayController.searchResultsDelegate = self;
        self.searchDisplayController.searchResultsDataSource = self;
        self.searchDisplayController.delegate = self;
        self.searchBar.frame = CGRectMake(0, 0, 0, 38);
        self.tableView.tableHeaderView = self.searchBar;
    }
}

-(void)createToolBar{
    if (self.tableView && self.toolbarItems.count == 0) {
        
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *addButtonImage = [UIImage imageNamed:@"BarButton_Add.png"];
        
        [addButton setFrame:CGRectMake(0.0, 0.0, addButtonImage.size.width, addButtonImage.size.height)];
        [addButton setBackgroundImage:addButtonImage forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(addNewIssue) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *createButton = [[UIBarButtonItem alloc] initWithCustomView:addButton];
        
        UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *refreshButtonImage = [UIImage imageNamed:@"BarButton_Refresh.png"];
        
        [refreshButton setFrame:CGRectMake(0.0, 0.0, refreshButtonImage.size.width, refreshButtonImage.size.height)];
        [refreshButton setBackgroundImage:refreshButtonImage forState:UIControlStateNormal];
        [refreshButton addTarget:self action:@selector(refreshIssues) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *refreshBarButton = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
        
        UIButton *filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *filterButtonImage = [UIImage imageNamed:@"BarButton_Filter.png"];
        
        [filterButton setFrame:CGRectMake(0.0, 0.0, filterButtonImage.size.width, filterButtonImage.size.height)];
        [filterButton setBackgroundImage:filterButtonImage forState:UIControlStateNormal];
        [filterButton addTarget:self action:@selector(filter) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *filterBarButton = [[UIBarButtonItem alloc] initWithCustomView:filterButton];
        
        UIBarButtonItem	*flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        [self setToolbarItems:@[createButton, refreshBarButton, flex, filterBarButton] animated:YES];
        self.navigationController.toolbarHidden = NO;
        
        [createButton release];
        [refreshBarButton release];
        [filterBarButton release];
        [flex release];
    }
}

-(void)addNewIssue{
    Issue *issue = [Issue createEntity];
    issue.project_id = self.project.identifier; // this is important
    
    NBNIssueEditViewController *editViewController = [NBNIssueEditViewController loadViewControllerWithIssue:issue];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:editViewController];
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:navController animated:YES completion:nil];
    
    [navController release];
}

-(void)refreshIssues{
    self.HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:self.HUD];
    
	// Show the HUD while the provided method executes in a new thread
	[self.HUD show:YES];
    
    [[NBNIssuesConnection sharedConnection] loadIssuesForProject:self.project onSuccess:^{
        [self refreshDataSource];
        [self.HUD setHidden:YES];
    }];
}

-(void)refreshDataSource{    
    self.issues = [[[[[[NSManagedObjectContext MR_defaultContext] ofType:@"Issue"] where:@"project_id == %@", self.project.identifier] where:@"closed == 0"] orderBy:@"identifier"] toArray];
    [self.tableView reloadData];
}

-(void)filter{
    
    NBNIssueFilterViewController *issueFilterViewController = [NBNIssueFilterViewController loadViewControllerWithFilter:self.project.filter];
    issueFilterViewController.delegate = self;
    issueFilterViewController.project = self.project;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:issueFilterViewController];

    [self presentViewController:navController animated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.project.name;
    
    if ([self.project.isFavorite isEqualToNumber:[NSNumber numberWithBool:YES]] ) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"Unstar" forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.f]];
        [button setTitleColor:[UIColor colorWithWhite:1.f alpha:1.f] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(0, 0, 58.f, 27.f)];
        [button addTarget:self action:@selector(starThisProject) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:@"BarButtonPlain.png"] forState:UIControlStateNormal];
        
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    } else{
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"Star" forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.f]];
        [button setTitleColor:[UIColor colorWithWhite:1.f alpha:1.f] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(0, 0, 58.f, 27.f)];
        [button addTarget:self action:@selector(starThisProject) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:@"BarButtonPlain.png"] forState:UIControlStateNormal];
        
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshIssues];
    [self createToolBar];
    [self.navigationController setToolbarHidden:NO animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.toolbarHidden = YES;
    [[NBNIssuesConnection sharedConnection] cancelIssuesConnection];
    [self.navigationController setToolbarHidden:YES animated:YES];
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
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.issuesSearchResults count];
    } else{
        return self.issues.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    NBNIssueCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [NBNIssueCell loadCellFromNib];
    }
    
    Issue *issue;
    if (tableView == self.searchDisplayController.searchResultsTableView){
        issue = [self.issuesSearchResults objectAtIndex:indexPath.row];
    } else{
        issue = [self.issues objectAtIndex:indexPath.row];
    }

    [cell configureCellWithIssue:issue];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Issue *issue;
    if (tableView == self.searchDisplayController.searchResultsTableView){
        issue = [self.issuesSearchResults objectAtIndex:indexPath.row];
    } else{
        issue = [self.issues objectAtIndex:indexPath.row];
    }
    
    NBNIssueDetailViewController *issueController = [NBNIssueDetailViewController loadViewControllerWithIssue:issue];
    [self.navigationController pushViewController:issueController animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NBNIssueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!cell) {
        cell = [NBNIssueCell loadCellFromNib];
    }
    
    Issue *issue;
    if (tableView == self.searchDisplayController.searchResultsTableView){
        issue = [self.issuesSearchResults objectAtIndex:indexPath.row];
    } else{
        issue = [self.issues objectAtIndex:indexPath.row];
    }
    
    [cell configureCellWithIssue:issue];
    return [cell getCalculatedHeight:issue];
}

#pragma mark - Search

-(void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope{
    self.issuesSearchResults = [[[[NSManagedObjectContext MR_defaultContext] ofType:@"Issue"] where:@"title contains[cd] %@",searchText] toArray];
    PBLog(@"searching %@ found %i results", searchText, self.issuesSearchResults.count);
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text]
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    return YES;
}

-(void)starThisProject{
    if ([self.project.isFavorite isEqualToNumber:[NSNumber numberWithBool:YES]] ) {
        self.project.isFavorite = [NSNumber numberWithBool:NO];
    } else{
        self.project.isFavorite = [NSNumber numberWithBool:YES];
    }
    
    if ([self.project.isFavorite isEqualToNumber:[NSNumber numberWithBool:YES]] ) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"Unstar" forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.f]];
        [button setTitleColor:[UIColor colorWithWhite:1.f alpha:1.f] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(0, 0, 58.f, 27.f)];
        [button addTarget:self action:@selector(starThisProject) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:@"BarButtonPlain.png"] forState:UIControlStateNormal];
        
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    } else{
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"Star" forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.f]];
        [button setTitleColor:[UIColor colorWithWhite:1.f alpha:1.f] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(0, 0, 58.f, 27.f)];
        [button addTarget:self action:@selector(starThisProject) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:@"BarButtonPlain.png"] forState:UIControlStateNormal];
        
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    }
}


-(void)applyFilter:(NSDictionary *)filterDictionary{
    
}

- (void)dealloc
{
    self.project = nil;
    self.issues = nil;
    self.searchDisplayController = nil;
    self.searchBar = nil;
    self.issuesSearchResults = nil;
    self.HUD = nil;
    
    [project release];
    [issues release];
    [searchDisplayController release];
    [searchBar release];
    [issuesSearchResults release];
    [HUD release];
    
    PBLog(@"deallocing %@", [self class]);
    [super dealloc];
}

@end
