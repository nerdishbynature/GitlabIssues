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

@interface NBNFindReposViewController ()

@property (nonatomic, retain) NSArray *projectsArray;
@property (nonatomic, retain) UISearchDisplayController *searchDisplayController;
@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) NSArray *projectsSearchResults;

@end

@implementation NBNFindReposViewController
@synthesize projectsArray;
@synthesize searchDisplayController;
@synthesize searchBar;
@synthesize projectsSearchResults;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [self createSearchBar];
    }
    return self;
}

- (void)createSearchBar {
    
    if (self.tableView && !self.tableView.tableHeaderView) {
        self.searchBar = [[[UISearchBar alloc] init] autorelease];
        self.searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        self.searchDisplayController.searchResultsDelegate = self;
        self.searchDisplayController.searchResultsDataSource = self;
        self.searchDisplayController.delegate = self;
        searchBar.frame = CGRectMake(0, 0, 0, 38);
        self.tableView.tableHeaderView = self.searchBar;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [NBNProjectConnection loadProjectsForDomain:[[Domain findAll] objectAtIndex:0] onSuccess:^{
        self.projectsArray = [Project findAllSortedBy:@"identifier" ascending:YES];
        [self.tableView reloadData];
    }];
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
    if ([self.tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    Project *project = [self.projectsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = project.name;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Project *project;
    if ([self.tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        project = [self.projectsSearchResults objectAtIndex:indexPath.row];
    } else{
        project = [self.projectsArray objectAtIndex:indexPath.row];
    }
    
    NBNIssuesViewController *issues = [NBNIssuesViewController loadWithProject:project];
    [self.navigationController pushViewController:issues animated:YES];
    [issues release];
}

-(void)dealloc{
    self.projectsArray = nil;
    
    [projectsArray release];
    [super dealloc];
}

@end
