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

@interface NBNIssuesViewController ()

@property (nonatomic, retain) Project *project;
@property (nonatomic, retain) NSArray *issues;

@end

@implementation NBNIssuesViewController
@synthesize project;
@synthesize issues;

+(NBNIssuesViewController *)loadWithProject:(Project *)_project{
    NBNIssuesViewController *issueViewController = [[NBNIssuesViewController alloc] initWithStyle:UITableViewStylePlain];
    issueViewController.project = _project;
    
    return issueViewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [NBNIssuesConnection loadIssuesForProject:self.project onSuccess:^{
        self.issues = [Issue findAllSortedBy:@"identifier" ascending:YES];
        [self.tableView reloadData];
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Star" style:UIBarButtonItemStyleBordered target:self action:@selector(starThisProject)];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
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
    return self.issues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    Issue *issue = [self.issues objectAtIndex:indexPath.row];
    cell.textLabel.text = issue.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Created by %@", issue.author.name];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

-(void)starThisProject{
    if ([self.project.isFavorite isEqualToNumber:[NSNumber numberWithBool:YES]] ) {
        self.project.isFavorite = [NSNumber numberWithBool:NO];
    } else{
        self.project.isFavorite = [NSNumber numberWithBool:YES];
    }
}

- (void)dealloc
{
    self.project = nil;
    self.issues = nil;
    
    [project release];
    [issues release];
    [super dealloc];
}

@end
