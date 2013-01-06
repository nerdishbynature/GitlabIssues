//
//  NBNLabelsListViewController.m
//  GitLabIssues
//
//  Created by Piet Brauer on 17.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import "NBNLabelsListViewController.h"
#import "NBNLabelsConnection.h"

@interface NBNLabelsListViewController ()

@property (nonatomic, retain) NSArray *labelsArray;
@property (nonatomic, retain) NSArray *labelsSearchArray;
@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) UISearchDisplayController *searchDisplayController;
@property (nonatomic, assign) NSUInteger projectID;

@end

@implementation NBNLabelsListViewController
@synthesize labelsArray;
@synthesize labelsSearchArray;
@synthesize searchBar;
@synthesize searchDisplayController;
@synthesize delegate;
@synthesize projectID;

+(NBNLabelsListViewController *)loadControllerWithProjectID:(NSUInteger)_projectID{
    NBNLabelsListViewController *listController = [[[NBNLabelsListViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
    listController.projectID = _projectID;
    listController.title = @"Milestones";
    [listController createSearchBar];
    
    return listController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [NBNLabelsConnection loadAllLabelsForProjectID:self.projectID onSuccess:^{
//        self.labelsArray = [[[[NSManagedObjectContext MR_defaultContext] ofType:@"Milestone"] where:@"project_id == %i", projectID] toArray];
//        [self.tableView reloadData];
//    }];
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
        return self.labelsSearchArray.count;
    } else{
        return self.labelsArray.count;
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
    
//    Label *label;
//    
//    if (tableView == self.searchDisplayController.searchResultsTableView) {
//        label = [self.labelsSearchArray objectAtIndex:indexPath.row];
//    } else{
//        label = [self.labelsArray objectAtIndex:indexPath.row];
//    }
//    
//    cell.textLabel.text = label.title;
    
    return cell;
}


#pragma mark - Search

-(void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope{
    self.labelsSearchArray = [[[[NSManagedObjectContext MR_defaultContext] ofType:@"Label"] where:@"title contains[cd] %@", searchText] toArray];
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
//        Label *label;
//        
//        if (tableView == self.searchDisplayController.searchResultsTableView) {
//            label = [self.labelsSearchArray objectAtIndex:indexPath.row];
//        } else{
//            label = [self.labelsArray objectAtIndex:indexPath.row];
//        }
//        
//        [self.delegate didSelectLabel:label];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    self.labelsArray = nil;
    self.labelsSearchArray = nil;
    self.searchBar = nil;
    self.searchDisplayController = nil;
    
    [labelsArray release];
    [labelsSearchArray release];
    [searchBar release];
    [searchDisplayController release];
    
    [super dealloc];
}

@end
