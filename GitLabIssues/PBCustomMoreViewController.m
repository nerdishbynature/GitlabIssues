//
//  PBCustomMoreViewController.m
//  HotelApp
//
//  Created by Piet Brauer on 25.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PBCustomMoreViewController.h"

@implementation PBCustomMoreViewController
@synthesize viewController;
@synthesize rootItems;

-(id)initWithViewController:(NSArray *)_viewController andRootItems:(NSArray *)items{
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        viewController = _viewController;
        rootItems = items;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"More"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    return viewController.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    UIViewController *controller = [viewController objectAtIndex:indexPath.row];
    
    cell.textLabel.text = controller.tabBarItem.title;
    cell.textLabel.textColor = [UIColor whiteColor];
    
    PBTabItem *item = [rootItems objectAtIndex:4+indexPath.row];
    cell.imageView.image = [UIImage imageNamed:item.unselectedImageNamed];
    
    return cell;
}

@end
