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

@interface NBNFavoritesViewController ()

@property (nonatomic, retain) NSArray *favoriteArray;

@end

@implementation NBNFavoritesViewController
@synthesize favoriteArray;

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

    
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.editButtonItem setAction:@selector(enterEditMode:)];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshFavorites];
}

-(void)refreshFavorites{
    self.favoriteArray = [[[[NSManagedObjectContext MR_defaultContext] ofType:@"Project"] where:@"isFavorite == 1"] toArray];
    [self.tableView reloadData];
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
    
    [favoriteArray release];
    [super dealloc];
}

#pragma mark - IBActions

-(IBAction)enterEditMode:(id)sender {
    
    if ([self.tableView isEditing]) {
        //Turn off edit mode
        [self.tableView setEditing:NO animated:YES];
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(enterEditMode:)] autorelease];
    }
    else {
        // Turn on edit mode
        [self.tableView setEditing:YES animated:YES];
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(enterEditMode:)] autorelease];
    }
}

#pragma mark - FilterDelegate

-(void)applyFilter:(NSDictionary *)filterDictionary{
    PBLog(@"WARNING - Filter is getting ignored");
}

@end
