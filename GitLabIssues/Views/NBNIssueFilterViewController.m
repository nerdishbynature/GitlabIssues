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
#import "NBNFilterSegmentedCell.h"

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
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel:)] autorelease];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(apply:)] autorelease];
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
    
    
    if (indexPath.section == 0) {// 
        static NSString  *CellIdentifier = @"ComponentsCellIdentifier";
        
        NBNFilterComponentsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [NBNFilterComponentsCell loadCellFromNib];
        }
        
        switch (indexPath.row) {
            case 0: // Assignee
                [cell configureCellWithAssignee:self.filter.assigned];
                break;

            case 1: // Milestone
                [cell configureCellWithMilestone:self.filter.milestone];
                break;
                
            case 2: // Labels
                [cell configureCellWithLabels:self.filter.labels];
                break;
                
            default:
                break;
        }
        
        return cell;
        
    } else if (indexPath.section == 1){ // open/closed Issues
        static NSString  *CellIdentifier = @"SegmentedCellIdentifier";
        
        NBNFilterSegmentedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [NBNFilterSegmentedCell loadCellFromNib];
        }
        
        [cell configureCellIsClosedCell:YES];
        return cell;
        
        
    } else{ // sort created or updated
        static NSString  *CellIdentifier = @"SegmentedCellIdentifier";
        
        NBNFilterSegmentedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [NBNFilterSegmentedCell loadCellFromNib];
        }
        
        [cell configureCellIsClosedCell:NO];
        
        return cell;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBActions

-(void)statusValueChanged:(id)sender{

}

-(void)sortIssuesValueChanged:(id)sender{
    
}

- (void)addAssignedUsers:(UIButton *)sender {

}

- (void)addMilestones:(UIButton *)sender {
    NBNMilestonesListViewController *listController = [NBNMilestonesListViewController loadControllerWithProjectID:[self.project.identifier integerValue]];
    listController.delegate = self;
    
    [self.navigationController pushViewController:listController animated:YES];
    [listController release];
}

- (void)addLabels:(UIButton *)sender {

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
    
    [super dealloc];
}


#pragma mark - Delegates

-(void)didSelectMilestone:(Milestone *)selectedMilestone{
    
}

@end
