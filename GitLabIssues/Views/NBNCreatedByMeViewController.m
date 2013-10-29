//
//  NBNCreatedByMeViewController.m
//  GitLabIssues
//
//  Created by Piet Brauer on 30.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import "NBNCreatedByMeViewController.h"
#import "Issue.h"
#import "Session.h"
#import "Project.h"
#import "NBNIssueCell.h"
#import "NBNIssueDetailViewController.h"
#import "NBNProjectConnection.h"
#import "NBNIssuesConnection.h"
#import "MBProgressHUD.h"
#import "NBNGroupedTableViewHeader.h"

@interface NBNCreatedByMeViewController ()

@property (nonatomic, strong) NSMutableArray *projects;
@property (nonatomic, strong) MBProgressHUD *HUD;

@end

@implementation NBNCreatedByMeViewController
@synthesize projects;
@synthesize HUD;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadResults];
    self.tabBarController.title = NSLocalizedString(@"Created By Me", nil);
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.view addSubview:HUD];
	
	// Regiser for HUD callbacks so we can remove it from the window at the right time
	HUD.delegate = self;
	
	// Show the HUD while the provided method executes in a new thread
	[HUD show:YES];
    [self loadAllIssues];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NBNProjectConnection sharedConnection] cancelProjectsConnection];
    [[NBNIssuesConnection sharedConnection] cancelAllIssuesConnection];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadAllIssues{

    [[NBNProjectConnection sharedConnection] loadProjectsForDomain:[[Domain MR_findAll] lastObject] onSuccess:^{
        [[NBNIssuesConnection sharedConnection] loadAllIssuesOnSuccess:^{
            [self reloadResults];
            [self.HUD hide:YES];
            [self.HUD removeFromSuperview];
        }];
    }];
    
    
}

-(void)reloadResults{
    
    [Session getCurrentSessionWithCompletion:^(Session *session) {
        NSArray *projectArray = [[[[NSManagedObjectContext MR_defaultContext] ofType:@"Project"] orderByDescending:@"identifier"] toArray];
        
        self.projects = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < projectArray.count; i++) {
            Project *project = [projectArray objectAtIndex:i];
            
            NSArray *issues = [[[[[[[NSManagedObjectContext MR_defaultContext] ofType:@"Issue"] where:@"author.identifier == %@", session.identifier] where:@"closed == 0"] where:@"project_id == %@", project.identifier] orderByDescending:@"updated_at"] toArray];
            NSDictionary *dict = @{@"name" : project.name, @"issues": issues};
            
            if (issues.count > 0) {
                [self.projects addObject:dict];
            }
        }
        
        [self.tableView reloadData];
    }];
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
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSDictionary *dict = [self.projects objectAtIndex:section];

    NBNGroupedTableViewHeader *header = [NBNGroupedTableViewHeader loadViewFromNib];
    [header configureWithTitle:[dict objectForKey:@"name"]];
    
    return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 22.f;
}

- (void)dealloc
{
    
    PBLog(@"deallocing %@", [self class]);
}

@end
