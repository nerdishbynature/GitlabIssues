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

@interface NBNFavoritesViewController ()

@property (nonatomic, retain) NSArray *favoriteArray;
@property (nonatomic, retain) MBProgressHUD *HUD;

@end

@implementation NBNFavoritesViewController
@synthesize favoriteArray;
@synthesize HUD;

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
    [self createEditButton];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshFavorites];
}

-(void)refreshFavorites{
    self.HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
    
	// Show the HUD while the provided method executes in a new thread
	[HUD show:YES];
    self.favoriteArray = [[[[NSManagedObjectContext MR_defaultContext] ofType:@"Project"] where:@"isFavorite == 1"] toArray];
    [self.tableView reloadData];
    [HUD setHidden:YES];
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
    NBNIssueFilterViewController *issueFilterViewController = [[NBNIssueFilterViewController alloc] initWithNibName:@"NBNIssueFilterViewController" bundle:nil];
    issueFilterViewController.delegate = self;
    issueFilterViewController.project = [self.favoriteArray objectAtIndex:indexPath.row];
    
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
    
    [favoriteArray release];
    [HUD release];
    PBLog(@"deallocing %@", [self class]);
    [super dealloc];
}

#pragma mark - IBActions

-(IBAction)enterEditMode:(id)sender {
    
    if ([self.tableView isEditing]) {
        //Turn off edit mode
        [self.tableView setEditing:NO animated:YES];
        [self createDoneButton];
    }
    else {
        // Turn on edit mode
        [self.tableView setEditing:YES animated:YES];
        [self createEditButton];
    }
}

-(void)createEditButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Edit" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithWhite:1.f alpha:1.f] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, 58.f, 27.f)];
    [button addTarget:self action:@selector(enterEditMode:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"BarButtonPlain.png"] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
}

-(void)createDoneButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Done" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithWhite:1.f alpha:1.f] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, 58.f, 27.f)];
    [button addTarget:self action:@selector(enterEditMode:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"BarButtonPlain.png"] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
}

#pragma mark - FilterDelegate

-(void)applyFilter:(NSDictionary *)filterDictionary{
    PBLog(@"WARNING - Filter is getting ignored");
}

@end
