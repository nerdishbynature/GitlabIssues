//
//  NBNAssigneeListViewController.m
//  GitLabIssues
//
//  Created by Piet Brauer on 12.01.13.
//  Copyright (c) 2013 nerdishbynature. All rights reserved.
//

#import "NBNAssigneeListViewController.h"
#import "NBNBackButtonHelper.h"
#import "NBNUsersConnection.h"
#import "Assignee.h"

@interface NBNAssigneeListViewController ()

@property (nonatomic, retain) NSArray *membersArray;
@property (nonatomic, retain) NSArray *membersSearchArray;
@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) UISearchDisplayController *searchDisplayController;
@property (nonatomic, assign) NSUInteger projectID;

@end

@implementation NBNAssigneeListViewController
@synthesize membersArray;
@synthesize membersSearchArray;
@synthesize searchBar;
@synthesize searchDisplayController;
@synthesize delegate;
@synthesize projectID;

+(NBNAssigneeListViewController *)loadControllerWithProjectID:(NSUInteger)_projectID{
    NBNAssigneeListViewController *listController = [[[NBNAssigneeListViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
    listController.projectID = _projectID;
    listController.title = @"Assignees";
    [listController createSearchBar];
    
    return listController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [NBNBackButtonHelper setCustomBackButtonForViewController:self andNavigationItem:self.navigationItem];
    [[NBNUsersConnection sharedConnection] loadMembersWithProjectID:self.projectID onSuccess:^(NSArray *array) {
        self.membersArray = array;
        [self.tableView reloadData];
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)createSearchBar {
    
    if (self.tableView && !self.tableView.tableHeaderView) {
        self.searchBar = [[[UISearchBar alloc] init] autorelease];
        self.searchDisplayController = [[[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self] autorelease];
        self.searchDisplayController.searchResultsDelegate = self;
        self.searchDisplayController.searchResultsDataSource = self;
        self.searchDisplayController.delegate = self;
        self.searchBar.frame = CGRectMake(0, 0, 0, 38);
        self.tableView.tableHeaderView = self.searchBar;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return self.membersSearchArray.count;
    } else{
        return self.membersArray.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    Assignee *assignee;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        assignee = [self.membersSearchArray objectAtIndex:indexPath.row];
    } else{
        assignee = [self.membersArray objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.text = assignee.name;
    
    return cell;
}


#pragma mark - Search

-(void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope{
    self.membersSearchArray = [[[[NSManagedObjectContext MR_defaultContext] ofType:@"Assignee"] where:@"name contains[cd] %@", searchText] toArray];
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.delegate) {
        Assignee *assignee;
        
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            assignee = [self.membersSearchArray objectAtIndex:indexPath.row];
        } else{
            assignee = [self.membersArray objectAtIndex:indexPath.row];
        }
        
        [self.delegate didSelectAssignee:assignee];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pushBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    self.membersArray = nil;
    self.membersSearchArray = nil;
    self.searchBar = nil;
    self.searchDisplayController = nil;
    
    [membersArray release];
    [membersSearchArray release];
    [searchDisplayController release];
    
    PBLog(@"deallocing %@", [self class]);
    [super dealloc];
}

@end