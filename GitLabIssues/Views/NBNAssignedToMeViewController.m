//
//  NBNAssignedToMeViewController.m
//  GitLabIssues
//
//  Created by Piet Brauer on 30.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import "NBNAssignedToMeViewController.h"
#import "Issue.h"
#import "Session.h"
#import "Project.h"
#import "NBNIssueCell.h"
#import "NBNIssueDetailViewController.h"

@interface NBNAssignedToMeViewController ()

@property (nonatomic, retain) NSMutableArray *projects;

@end

@implementation NBNAssignedToMeViewController
@synthesize projects;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    Session *session = [[Session findAll] objectAtIndex:0];
    self.projects = [[NSMutableArray alloc] init];
    
    NSArray *projectArray = [[[NSManagedObjectContext MR_defaultContext] ofType:@"Project"] toArray];
    
    for (Project *project in projectArray) {
        NSArray *issues = [[[[[[[NSManagedObjectContext MR_defaultContext] ofType:@"Issue"] where:@"assignee.identifier == %@", session.identifier] where:@"closed == 0"] where:@"project_id == %@", project.identifier] orderBy:@"identifier"] toArray];
        NSDictionary *dict = @{@"name" : project.name, @"issues": issues};
        
        if (issues.count > 0) {
            [self.projects addObject:dict];
        }
    }
    
    [self.tableView reloadData];
    
    self.title = @"Assigned To Me";
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
    return self.projects.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSDictionary *dict = [self.projects objectAtIndex:section];
    NSArray *issues = [dict objectForKey:@"issues"];
    return issues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    NBNIssueCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [NBNIssueCell loadCellFromNib];
    }
    
    NSDictionary *dict = [self.projects objectAtIndex:indexPath.section];
    NSArray *issues = [dict objectForKey:@"issues"];
    Issue *issue = [issues objectAtIndex:indexPath.row];
    
    [cell configureCellWithIssue:issue];
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSDictionary *dict = [self.projects objectAtIndex:section];
    return [dict objectForKey:@"name"];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NBNIssueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!cell) {
        cell = [NBNIssueCell loadCellFromNib];
    }
    
    NSDictionary *dict = [self.projects objectAtIndex:indexPath.section];
    NSArray *issues = [dict objectForKey:@"issues"];
    Issue *issue = [issues objectAtIndex:indexPath.row];
    
    [cell configureCellWithIssue:issue];
    
    return [cell getCalculatedHeight:issue];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.projects objectAtIndex:indexPath.section];
    NSArray *issues = [dict objectForKey:@"issues"];
    Issue *issue = [issues objectAtIndex:indexPath.row];
    
    NBNIssueDetailViewController *issueController = [NBNIssueDetailViewController loadViewControllerWithIssue:issue];
    [self.navigationController pushViewController:issueController animated:YES];
    
    [issueController release];
}

@end
