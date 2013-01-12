//
//  NBNProjectsViewController.m
//  GitLabIssues
//
//  Created by Piet Brauer on 16.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import "NBNProjectsViewController.h"
#import "Project.h"
#import "NBNProjectConnection.h"
#import "NBNIssuesViewController.h"
#import "MBProgressHUD.h"
#import "NBNBackButtonHelper.h"

@interface NBNProjectsViewController ()

@property (nonatomic, retain) NSArray *projectsArray;
@property (nonatomic, retain) MBProgressHUD *HUD;

@end

@implementation NBNProjectsViewController
@synthesize projectsArray;
@synthesize HUD;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"Projects";
        [self refreshDataSource];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [NBNBackButtonHelper setCustomBackButtonForViewController:self andNavigationItem:self.navigationItem];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	// Regiser for HUD callbacks so we can remove it from the window at the right time
	HUD.delegate = self;
	
	// Show the HUD while the provided method executes in a new thread
	[HUD show:YES];
    
    [[NBNProjectConnection sharedConnection] loadProjectsForDomain:[[Domain findAll] objectAtIndex:0] onSuccess:^{
        [self refreshDataSource];
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NBNProjectConnection sharedConnection] cancelProjectsConnection];
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
    return self.projectsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    Project *project = [self.projectsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = project.name;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	// Regiser for HUD callbacks so we can remove it from the window at the right time
	HUD.delegate = self;
	
	// Show the HUD while the provided method executes in a new thread
	[HUD showWhileExecuting:@selector(navigateToIssues:) onTarget:self withObject:(Project *)[self.projectsArray objectAtIndex:indexPath.row] animated:YES];
}

-(void)navigateToIssues:(Project *)project{
    NBNIssuesViewController *issues = [NBNIssuesViewController loadWithProject:project];
    [self.navigationController pushViewController:issues animated:YES];
}

-(void)refreshDataSource{
    self.projectsArray = [[[[NSManagedObjectContext MR_defaultContext] ofType:@"Project"] orderByDescending:@"identifier"] toArray];
    [self.tableView reloadData];
    [self.HUD setHidden:YES];
}

- (void)pushBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc{
    self.projectsArray = nil;
    self.HUD = nil;
    
    [projectsArray release];
    [HUD release];
    
    PBLog(@"deallocing %@", [self class]);
    [super dealloc];
}


@end
