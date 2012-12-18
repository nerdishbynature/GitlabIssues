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

@interface NBNIssuesViewController ()

@property (nonatomic, retain) Project *project;
@property (nonatomic, retain) NSArray *issues;
@property (nonatomic, retain) UISearchDisplayController *searchDisplayController;
@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) NSArray *issuesSearchResults;

@end

@implementation NBNIssuesViewController
@synthesize project;
@synthesize issues;
@synthesize searchDisplayController;
@synthesize searchBar;
@synthesize issuesSearchResults;

+(NBNIssuesViewController *)loadWithProject:(Project *)_project{
    NBNIssuesViewController *issueViewController = [[NBNIssuesViewController alloc] initWithStyle:UITableViewStylePlain];
    issueViewController.project = _project;
    [issueViewController createSearchBar];
    return issueViewController;
}

- (void)createSearchBar {

    if (self.tableView && !self.tableView.tableHeaderView) {
        self.searchBar = [[[UISearchBar alloc] init] autorelease];
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
        UIBarButtonItem *createButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(addNewIssue)];
        UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshIssues)];
        UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(filter)];
        UIBarButtonItem	*flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        [self setToolbarItems:@[createButton, refreshButton, flex, filterButton] animated:YES];
        self.navigationController.toolbarHidden = NO;
    }
}

-(void)addNewIssue{
    Issue *issue = [Issue createEntity];
    issue.project_id = self.project.identifier; // this is important
    
    NBNIssueEditViewController *editViewController = [NBNIssueEditViewController loadViewControllerWithIssue:issue];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:editViewController];
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:navController animated:YES completion:nil];
    
    [editViewController release];
    [navController release];
}

-(void)refreshIssues{
    [NBNIssuesConnection loadIssuesForProject:self.project onSuccess:^{
        self.issues = [[[[[NSManagedObjectContext MR_defaultContext] ofType:@"Issue"] where:@"project_id == %@", self.project.identifier] orderBy:@"identifier"] toArray];
        [self.tableView reloadData];
    }];
}

-(void)filter{
    NBNIssueFilterViewController *issueFilterViewController = [[NBNIssueFilterViewController alloc] initWithNibName:@"NBNIssueFilterViewController" bundle:nil];
    issueFilterViewController.delegate = self;
    issueFilterViewController.project = self.project;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:issueFilterViewController];
    [issueFilterViewController release];
    
    navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:navController animated:YES completion:nil];
    
    [navController release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.project.name;
    
    [self refreshIssues];
        
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Star" style:UIBarButtonItemStyleBordered target:self action:@selector(starThisProject)];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self createToolBar];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveNestedContexts];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    Issue *issue;
    if (tableView == self.searchDisplayController.searchResultsTableView){
        issue = [self.issuesSearchResults objectAtIndex:indexPath.row];
    } else{
        issue = [self.issues objectAtIndex:indexPath.row];
    }

    cell.textLabel.text = issue.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Created by %@", issue.author.name];
    
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
    
    [issueController release];
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
    
    [project release];
    [issues release];
    [searchDisplayController release];
    [searchBar release];
    [issuesSearchResults release];
    [super dealloc];
}

@end
