//
//  NBNIssueFilterViewController.m
//  GitLabIssues
//
//  Created by Piet Brauer on 17.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import "NBNIssueFilterViewController.h"
#import "NBNMilestonesListViewController.h"
#import "Project.h"
#import "Filter.h"
#import "Assignee.h"
#import "NBNFilterComponentsCell.h"
#import "NBNFilterSortCell.h"
#import "NBNFilterStatusCell.h"

NSString *const kKeyAssignedFilter = @"kKeyAssignedFilter";
NSString *const kKeyMilestoneFilter = @"kKeyMilestoneFilter";
NSString *const kKeyLabelsFilter = @"kKeyLabelsFilter";
NSString *const kKeyIssueStatusFilter = @"kKeyIssueStatusFilter";
NSString *const kKeySortIssuesFilter = @"kKeySortIssuesFilter";

@interface NBNIssueFilterViewController ()

@property (nonatomic, retain) Filter *filter;


@end

@implementation NBNIssueFilterViewController

@synthesize delegate;
@synthesize project;
@synthesize filter;

+(NBNIssueFilterViewController *)loadViewControllerWithFilter:(Filter *)_filter{
    NBNIssueFilterViewController *filterController = [[[NBNIssueFilterViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
    filterController.filter = _filter;
    //[filterController configureView];
    
    return filterController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setTitle:@"Cancel" forState:UIControlStateNormal];
	[button.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.f]];
	[button setTitleColor:[UIColor colorWithWhite:1.f alpha:1.f] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, 58.f, 27.f)];
    [button addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"BarButtonPlain.png"] forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    
    UIButton *applybutton = [UIButton buttonWithType:UIButtonTypeCustom];
	[applybutton setTitle:@"Apply" forState:UIControlStateNormal];
	[applybutton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.f]];
	[applybutton setTitleColor:[UIColor colorWithWhite:1.f alpha:1.f] forState:UIControlStateNormal];
    [applybutton setFrame:CGRectMake(0, 0, 58.f, 27.f)];
    [applybutton addTarget:self action:@selector(apply:) forControlEvents:UIControlEventTouchUpInside];
    [applybutton setBackgroundImage:[UIImage imageNamed:@"BarButtonPlain.png"] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:applybutton] autorelease];
    self.title = @"Issues Filter";
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 2; // labels are not yet supported
            break;
            
        default:
            return 1;
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {// Assignee and Milestone
        
        
        
        switch (indexPath.row) {
            case 0:
            {
                NBNFilterAssigneeCell *cell;
                
                static NSString  *CellIdentifier = @"ComponentsAssigneeCellIdentifier";
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (!cell) {
                    cell = [NBNFilterAssigneeCell loadCellFromNib];
                }
                
                [cell configureCellWithAssignee:self.filter.assigned];
                cell.delegate = self;
                
                return cell;
            }
                break;
            
            case 1:
            {
                NBNFilterComponentsCell *cell;
                
                static NSString  *CellIdentifier = @"ComponentsMilestoneCellIdentifier";
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (!cell) {
                    cell = [NBNFilterComponentsCell loadCellFromNib];
                }
                
                [cell configureCellWithMilestone:self.filter.milestone];
                cell.delegate = self;
                
                return cell;
            }
                break;
            default:
                return nil;
                break;
        }
        

        
    } else if (indexPath.section == 1){ // open/closed Issues
        static NSString  *CellIdentifier = @"SegmentedStatusCellIdentifier";
        
        NBNFilterStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[NBNFilterStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.delegate = self;
        cell.closed = [self.filter.closed boolValue];
        [cell configureView];
        
        return cell;
        
        
    } else{ // sort created or updated
        static NSString  *CellIdentifier = @"SegmentedSortCellIdentifier";
        
        NBNFilterSortCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[NBNFilterSortCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.delegate = self;
        cell.created = [self.filter.sortCreated boolValue];
        [cell configureView];
        
        return cell;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"";
    } else if (section == 1){
        return @"Issue Status";
    } else{
        return @"Sort Issues";
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: // Assignee
                [self addAssignee:nil];
                break;
            case 1:
                [self addMilestones:nil];
                break;
            default:
                break;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addMilestones:(UIButton *)sender {
    NBNMilestonesListViewController *listController = [NBNMilestonesListViewController loadControllerWithProjectID:[self.project.identifier integerValue]];
    listController.delegate = self;
    
    [self.navigationController pushViewController:listController animated:YES];
}

- (void)addAssignee:(UIButton *)sender {
    NBNAssigneeListViewController *listController = [NBNAssigneeListViewController loadControllerWithProjectID:[self.project.identifier integerValue]];
    listController.delegate = self;
    
    [self.navigationController pushViewController:listController animated:YES];
}

-(void)cancel:(id)sender{
    [self dismiss];
}

-(void)apply:(id)sender{
    if ([self.delegate respondsToSelector:@selector(applyFilter:)]) {
        [self.delegate applyFilter:self.filter];
    }
    
    [self dismiss];
}

-(void)dismiss{
    if (self.navigationController.viewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)dealloc {
    self.filter = nil;
    self.project = nil;
    
    [filter release];
    [project release];
    
    PBLog(@"deallocing %@", [self class]);
    [super dealloc];
}

#pragma mark - Delegates

-(void)didSelectAssignee:(Assignee *)selectedAssignee{
    self.filter.assigned = selectedAssignee;
    [self.tableView reloadData];
}

-(void)didSelectMilestone:(Milestone *)selectedMilestone{
    self.filter.milestone = selectedMilestone;
    [self.tableView reloadData];
}

-(void)didChangeStatusTo:(BOOL)closed{
    self.filter.closed = [NSNumber numberWithBool:closed];
}

-(void)didChangeSortingTo:(BOOL)created{
    self.filter.sortCreated = [NSNumber numberWithBool:created];
}

-(void)clearAssignee{
    self.filter.assigned = nil;
    [self.tableView reloadData];
}

-(void)clearMilestone{
    self.filter.milestone = nil;
    [self.tableView reloadData];
}

@end
