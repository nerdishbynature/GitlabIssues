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
#import "NBNBackButtonHelper.h"
#import "CKRefreshControl.h"

@interface NBNIssuesViewController ()

@property (nonatomic, strong) Project *project;
@property (nonatomic, strong) NSArray *issues;
@property (nonatomic, strong) UISearchDisplayController *searchDisplayController;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSArray *issuesSearchResults;
@property (nonatomic, strong) MBProgressHUD *HUD;

@end

@implementation NBNIssuesViewController
@synthesize project;
@synthesize issues;
@synthesize searchDisplayController;
@synthesize searchBar;
@synthesize issuesSearchResults;
@synthesize HUD;

+(NBNIssuesViewController *)loadWithProject:(Project *)_project{
    NBNIssuesViewController *issueViewController = [[NBNIssuesViewController alloc] initWithStyle:UITableViewStylePlain];
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
        createButton.accessibilityLabel = NSLocalizedString(@"Add", nil);
        
        UIButton *filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *filterButtonImage = [UIImage imageNamed:@"BarButton_Filter.png"];
        
        [filterButton setFrame:CGRectMake(0.0, 0.0, filterButtonImage.size.width, filterButtonImage.size.height)];
        [filterButton setBackgroundImage:filterButtonImage forState:UIControlStateNormal];
        [filterButton addTarget:self action:@selector(filter) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *filterBarButton = [[UIBarButtonItem alloc] initWithCustomView:filterButton];
        filterButton.accessibilityLabel = NSLocalizedString(@"Filter", nil);
        
        UIBarButtonItem	*flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        [self setToolbarItems:@[createButton, flex, filterBarButton] animated:YES];
        self.navigationController.toolbarHidden = NO;
        
    }
}

-(void)addNewIssue{
    Issue *issue = [Issue MR_createEntity];
    issue.project_id = self.project.identifier; // this is important
    
    NBNIssueEditViewController *editViewController = [NBNIssueEditViewController loadViewControllerWithIssue:issue];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:editViewController];
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:navController animated:YES completion:nil];
    
}

-(void)refreshIssues{
    self.HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:self.HUD];
    
	// Show the HUD while the provided method executes in a new thread
	[self.HUD show:YES];
    
    [[NBNIssuesConnection sharedConnection] loadIssuesForProject:self.project onSuccess:^{
        [self refreshDataSource];
        [self.HUD setHidden:YES];
        [self.HUD removeFromSuperview];
        [self.refreshControl endRefreshing];
    }];
}

-(void)refreshDataSource{
    if (self.project.filter) {
        [self reloadUsingFilter];
    } else{
        self.issues = [[[[[[NSManagedObjectContext MR_defaultContext] ofType:@"Issue"] where:@"project_id == %@", self.project.identifier] where:@"closed == 0"] orderBy:@"identifier"] toArray];
        [self.tableView reloadData];
    }
    
    [Flurry logEvent:@"number_of_issues" withParameters:@{@"project_id": self.project.identifier, @"count": [NSNumber numberWithInt:self.issues.count]}];
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
    [NBNBackButtonHelper setCustomBackButtonForViewController:self andNavigationItem:self.navigationItem];
    
    if ([self.project.isFavorite isEqualToNumber:[NSNumber numberWithBool:YES]] ) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:@"star_selected.png"];
        [button setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        [button addTarget:self action:@selector(starThisProject) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    } else{
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:@"star.png"];
        [button setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        [button addTarget:self action:@selector(starThisProject) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshIssues) forControlEvents:UIControlEventValueChanged];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshIssues];
    [self createToolBar];
    [self.navigationController setToolbarHidden:NO animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NBNIssuesConnection sharedConnection] cancelIssuesConnection];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
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
        UIImage *image = [UIImage imageNamed:@"star_selected.png"];
        [button setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        [button addTarget:self action:@selector(starThisProject) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    } else{
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:@"star.png"];
        [button setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        [button addTarget:self action:@selector(starThisProject) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
}


-(void)applyFilter:(Filter *)filter{
    self.project.filter = filter;
    [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfWithCompletion:nil];
}

-(void)reloadUsingFilter{
    NSString *predicateString = @"";
    
    predicateString = [predicateString stringByAppendingFormat:@"(project_id == %@) AND (closed == %@) ", self.project.identifier, self.project.filter.closed];
    
    if (self.project.filter.assigned) {
        predicateString = [predicateString stringByAppendingFormat:@"AND (assignee.identifier == %@) ", self.project.filter.assigned.identifier];
    }
    
    if (self.project.filter.milestone) {
        predicateString = [predicateString stringByAppendingFormat:@"AND (milestone.identifier == %@) ", self.project.filter.milestone.identifier];
    }
    
    if ([[predicateString substringFromIndex:predicateString.length-1] isEqualToString:@" "]) {
        predicateString = [predicateString substringToIndex:predicateString.length-1];
    }
    
    NSSortDescriptor *sortDescriptor;
    if (self.project.filter.sortCreated) {
        sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"created_at" ascending:NO];
    } else{
        sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"updated_at" ascending:NO];
    }
    
    PBLog(@"filter %@", predicateString);
    
    self.issues = [Issue MR_findAllWithPredicate:[NSPredicate predicateWithFormat:predicateString]];
    self.issues = [self.issues sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    [self.tableView reloadData];
}

- (void)pushBackButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    
    
    PBLog(@"deallocing %@", [self class]);
}

@end
