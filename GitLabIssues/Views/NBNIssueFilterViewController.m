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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(apply:)];
    self.title = @"Issues Filter";
    
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)apply:(id)sender{
    if (self.delegate) {
        [self.delegate applyFilter:self.filterDict];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    [addAssignedButton release];
    [addMilestoneButton release];
    [addLabelButton release];
    [filterDict release];

    [super dealloc];
}


#pragma mark - Delegates

-(void)didSelectMilestone:(Milestone *)selectedMilestone{
    
}

@end