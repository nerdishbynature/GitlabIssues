//
//  NBNFavoritesViewController.m
//  GitLabIssues
//
//  Created by Piet Brauer on 16.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import "NBNFavoritesViewController.h"
#import "NBNIssuesViewController.h"
#import "Project.h"
#import "NBNIssueFilterViewController.h"
#import "MBProgressHUD.h"
#import "NBNBackButtonHelper.h"

@interface NBNFavoritesViewController ()

@property (nonatomic, retain) NSArray *favoriteArray;
@property (nonatomic, retain) MBProgressHUD *HUD;
@property (nonatomic, retain) NSIndexPath *tappedIndexPath;

@end

@implementation NBNFavoritesViewController
@synthesize favoriteArray;
@synthesize HUD;
@synthesize tappedIndexPath;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"Favorites";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Edit" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.f]];
    [button setTitleColor:[UIColor colorWithWhite:1.f alpha:1.f] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, 58.f, 27.f)];
    [button addTarget:self action:@selector(enterEditMode:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"BarButtonPlain.png"] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    
    [NBNBackButtonHelper setCustomBackButtonForViewController:self andNavigationItem:self.navigationItem];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshFavorites];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

-(void)refreshFavorites{
    self.HUD = [[[MBProgressHUD alloc] initWithView:self.navigationController.view] autorelease];
	[self.view addSubview:HUD];
    
	// Show the HUD while the provided method executes in a new thread
	[HUD show:YES];
    self.favoriteArray = [[[[NSManagedObjectContext MR_defaultContext] ofType:@"Project"] where:@"isFavorite == 1"] toArray];
    [self.tableView reloadData];
    [HUD setHidden:YES];
    [HUD removeFromSuperview];
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
    return self.favoriteArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    
    Project *project = [self.favoriteArray objectAtIndex:indexPath.row];
    cell.textLabel.text = project.name;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    self.tappedIndexPath = indexPath;
    Project *project = [self.favoriteArray objectAtIndex:indexPath.row];
    
    NBNIssueFilterViewController *issueFilterViewController = [NBNIssueFilterViewController loadViewControllerWithFilter:project.filter];
    issueFilterViewController.delegate = self;
    
    [self.navigationController pushViewController:issueFilterViewController animated:YES];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Project *project = [self.favoriteArray objectAtIndex:indexPath.row];
        project.isFavorite = [NSNumber numberWithBool:NO];
        
        [self refreshFavorites];
    }     
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NBNIssuesViewController *issuesViewController = [NBNIssuesViewController loadWithProject:(Project *)[self.favoriteArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:issuesViewController animated:YES];
}

-(void)dealloc{
    self.favoriteArray = nil;
    self.HUD = nil;
    self.tappedIndexPath = nil;
    
    [tappedIndexPath release];
    [favoriteArray release];
    [HUD release];
    PBLog(@"deallocing %@", [self class]);
    [super dealloc];
}

#pragma mark - IBActions

-(IBAction)enterEditMode:(id)sender {
    
    if (self.tableView.isEditing) {
        //Turn off edit mode
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:@"Edit" forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.f]];
        [button setTitleColor:[UIColor colorWithWhite:1.f alpha:1.f] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(0, 0, 58.f, 27.f)];
        [button addTarget:self action:@selector(enterEditMode:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:@"BarButtonPlain.png"] forState:UIControlStateNormal];
        
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
        [self.tableView setEditing:NO animated:YES];
    }
    else {
        // Turn on edit mode
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"Done" forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.f]];
        [button setTitleColor:[UIColor colorWithWhite:1.f alpha:1.f] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(0, 0, 58.f, 27.f)];
        [button addTarget:self action:@selector(enterEditMode:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:@"BarButtonPlain.png"] forState:UIControlStateNormal];
        
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
        [self.tableView setEditing:YES animated:YES];
    }
}

#pragma mark - FilterDelegate

-(void)applyFilter:(Filter *)_filter{
    Project *project = [self.favoriteArray objectAtIndex:self.tappedIndexPath.row];
    project.filter = _filter;

    self.tappedIndexPath = nil;
    
    [[NSManagedObjectContext MR_defaultContext] save];
}

- (void)pushBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
