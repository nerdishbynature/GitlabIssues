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

NSString *const kKeyAssignedFilter = @"kKeyAssignedFilter";
NSString *const kKeyMilestoneFilter = @"kKeyMilestoneFilter";
NSString *const kKeyLabelsFilter = @"kKeyLabelsFilter";
NSString *const kKeyIssueStatusFilter = @"kKeyIssueStatusFilter";
NSString *const kKeySortIssuesFilter = @"kKeySortIssuesFilter";

@interface NBNIssueFilterViewController ()

@property (nonatomic, retain) IBOutlet UILabel *assignedLabel;
@property (nonatomic, retain) IBOutlet UILabel *assignedDescriptionLabel;
@property (nonatomic, retain) IBOutlet UILabel *milestoneLabel;
@property (nonatomic, retain) IBOutlet UILabel *milestoneDescriptionLabel;
@property (nonatomic, retain) IBOutlet UILabel *labelsLabel;
@property (nonatomic, retain) IBOutlet UILabel *labelDescriptionLabel;
@property (nonatomic, retain) IBOutlet UILabel *issueStatusHeaderLabel;
@property (nonatomic, retain) IBOutlet UISegmentedControl *statusSegementedControl;
@property (nonatomic, retain) IBOutlet UILabel *issueSortHeaderLabel;
@property (nonatomic, retain) IBOutlet UISegmentedControl *sortSegementedControl;
@property (retain, nonatomic) IBOutlet UIButton *addAssignedButton;
@property (retain, nonatomic) IBOutlet UIButton *addMilestoneButton;
@property (retain, nonatomic) IBOutlet UIButton *addLabelButton;
@property (nonatomic, retain) NSMutableDictionary *filterDict;
@property (nonatomic, retain) Filter *filter;


@end

@implementation NBNIssueFilterViewController
@synthesize assignedLabel;
@synthesize assignedDescriptionLabel;
@synthesize milestoneLabel;
@synthesize milestoneDescriptionLabel;
@synthesize labelsLabel;
@synthesize labelDescriptionLabel;
@synthesize issueStatusHeaderLabel;
@synthesize statusSegementedControl;
@synthesize issueSortHeaderLabel;
@synthesize sortSegementedControl;
@synthesize addAssignedButton;
@synthesize addMilestoneButton;
@synthesize addLabelButton;
@synthesize delegate;
@synthesize filterDict;
@synthesize project;
@synthesize filter;

+(NBNIssueFilterViewController *)loadViewControllerWithFilter:(Filter *)_filter{
    NBNIssueFilterViewController *filterController = [[[NBNIssueFilterViewController alloc] initWithNibName:@"NBNIssueFilterViewController" bundle:nil] autorelease];
    filterController.filter = _filter;
    [filterController configureView];
    
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

-(void)configureView{
    if (self.filter.assigned) {
        self.assignedDescriptionLabel.text = self.filter.assigned.name;
    }
    
    if (self.filter.milestone) {
        self.milestoneDescriptionLabel.text = self.filter.milestone.title;
    }
    
    
    NSMutableString *labelString = [[NSMutableString alloc] init];
    
    for (NSString *label in self.filter.labels) {
        if ([label isEqual:[((NSArray *)self.filter.labels) objectAtIndex:0]]) { // firstObject
            [labelString appendFormat:@", %@", label];
        } else{
            [labelString appendString:label];
        }
        
    }
    
    self.labelDescriptionLabel.text = labelString;
    [labelString release];
    
    if ([self.filter.closed boolValue] == YES) {
        self.statusSegementedControl.selectedSegmentIndex = 1;
    } else{
        self.statusSegementedControl.selectedSegmentIndex = 0;
    }
    
    if ([self.filter.sortCreated boolValue] == YES) { // Sort created
        self.statusSegementedControl.selectedSegmentIndex = 0;
    } else{                                            // Sort Updated
        self.statusSegementedControl.selectedSegmentIndex = 1;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBActions

-(IBAction)statusValueChanged:(id)sender{

}

-(IBAction)sortIssuesValueChanged:(id)sender{
    
}

- (IBAction)addAssignedUsers:(UIButton *)sender {

}

- (IBAction)addMilestones:(UIButton *)sender {
    NBNMilestonesListViewController *listController = [NBNMilestonesListViewController loadControllerWithProjectID:[self.project.identifier integerValue]];
    listController.delegate = self;
    
    [self.navigationController pushViewController:listController animated:YES];
    [listController release];
}

- (IBAction)addLabels:(UIButton *)sender {

}

-(void)cancel:(id)sender{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)apply:(id)sender{
    if ([self.delegate respondsToSelector:@selector(applyFilter:)]) {
        [self.delegate applyFilter:self.filterDict];
    }
    
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }

}

- (void)dealloc {
    self.assignedLabel = nil;
    self.assignedDescriptionLabel = nil;
    self.milestoneLabel = nil;
    self.milestoneDescriptionLabel = nil;
    self.labelsLabel = nil;
    self.labelDescriptionLabel = nil;
    self.issueStatusHeaderLabel = nil;
    self.statusSegementedControl = nil;
    self.issueSortHeaderLabel = nil;
    self.sortSegementedControl = nil;
    self.addAssignedButton = nil;
    self.addMilestoneButton = nil;
    self.addLabelButton = nil;
    self.filterDict = nil;
    self.filter = nil;
    
    [assignedLabel release];
    [assignedDescriptionLabel release];
    [milestoneLabel release];
    [labelsLabel release];
    [labelDescriptionLabel release];
    [issueStatusHeaderLabel release];
    [statusSegementedControl release];
    [issueSortHeaderLabel release];
    [sortSegementedControl release];
    [addAssignedButton release];
    [addMilestoneButton release];
    [addLabelButton release];
    [filterDict release];
    [filter release];
    
    [super dealloc];
}


#pragma mark - Delegates

-(void)didSelectMilestone:(Milestone *)selectedMilestone{
    
}

@end
