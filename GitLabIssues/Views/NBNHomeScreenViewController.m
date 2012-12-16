//
//  NBNHomeScreenViewController.m
//  GitLabIssues
//
//  Created by Piet Brauer on 16.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import "NBNHomeScreenViewController.h"
#import "NBNFavoritesViewController.h"
#import "NBNProjectsViewController.h"
#import "Domain.h"

@interface NBNHomeScreenViewController ()

@property (nonatomic, retain) NSArray *menuArray;
@property (nonatomic, retain) NSArray *domainArray;

@end

@implementation NBNHomeScreenViewController
@synthesize menuArray;
@synthesize domainArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"GitLab:Issues";
        self.menuArray = @[@"Favorites", @"Dashboard", @"Find Repos"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logout:)];
    self.navigationItem.rightBarButtonItem = item;
    [item release];
    
    self.domainArray = [Domain findAll];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return self.menuArray.count;
            break;

        case 1:
            return self.domainArray.count;
            break;
            
        default:
            return 1;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = [self.menuArray objectAtIndex:indexPath.row];
    } else{
        Domain *domain = (Domain*)[self.domainArray objectAtIndex:indexPath.row];
        cell.textLabel.text = domain.domain;
    }

    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    switch (indexPath.section) {
        case 0:
            return NO;
            break;
        case 1:
            return YES;
            break;
        default:
            return NO;
            break;
    }
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [[NSManagedObjectContext MR_defaultContext] delete:[self.domainArray objectAtIndex:indexPath.row]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }      
}
                             
#pragma mark - IBActions
                             
-(void)logout:(id)sender{
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) { //static
        
        if (indexPath.row == 0) { //favorites
            NBNFavoritesViewController *favorites = [[NBNFavoritesViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:favorites animated:YES];
            
            [favorites release];
        }
        
    } else if (indexPath.section == 1){
        NBNProjectsViewController *projects = [[NBNProjectsViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:projects animated:YES];
        
        [projects release];
    }
}

-(void)dealloc{
    [super dealloc];
    self.menuArray = nil;
    self.domainArray = nil;
    
    [menuArray release];
    [domainArray release];
}

@end
