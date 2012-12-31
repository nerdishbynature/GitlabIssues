//
//  NBNMilestonesListViewController.m
//  GitLabIssues
//
//  Created by Piet Brauer on 17.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import "NBNMilestonesListViewController.h"
#import "Milestone.h"
#import "NBNMilestoneConnection.h"

@interface NBNMilestonesListViewController ()

@property (nonatomic, retain) NSArray *milestonesArray;
@property (nonatomic, retain) NSArray *milestonesSearchArray;
@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) UISearchDisplayController *searchDisplayController;
@property (nonatomic, assign) NSUInteger projectID;

@end

@implementation NBNMilestonesListViewController
@synthesize milestonesArray;
@synthesize milestonesSearchArray;
@synthesize searchBar;
@synthesize searchDisplayController;
@synthesize delegate;
@synthesize projectID;

+(NBNMilestonesListViewController *)loadControllerWithProjectID:(NSUInteger)_projectID{
    NBNMilestonesListViewController *listController = [[[NBNMilestonesListViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
    listController.projectID = _projectID;
    listController.title = @"Milestones";
    [listController createSearchBar];
    
    return listController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [NBNMilestoneConnection loadAllMilestonesForProjectID:self.projectID onSuccess:^{
        self.milestonesArray = [[[[NSManagedObjectContext MR_defaultContext] ofType:@"Milestone"] where:@"project_id == %i", projectID] toArray];
        [self.tableView reloadData];
    }];
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
        return self.milestonesSearchArray.count;
    } else{
        return self.milestonesArray.count;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    Milestone *milestone;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        milestone = [self.milestonesSearchArray objectAtIndex:indexPath.row];
    } else{
        milestone = [self.milestonesArray objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.text = milestone.title;
    
    return cell;
}


#pragma mark - Search

-(void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope{
    self.milestonesSearchArray = [[[[NSManagedObjectContext MR_defaultContext] ofType:@"Milestone"] where:@"title contains[cd] %@", searchText] toArray];
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
        Milestone *milestone;
        
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            milestone = [self.milestonesSearchArray objectAtIndex:indexPath.row];
        } else{
            milestone = [self.milestonesArray objectAtIndex:indexPath.row];
        }
        
        [self.delegate didSelectMilestone:milestone];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
