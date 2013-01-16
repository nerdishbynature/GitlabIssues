//
//  NBNIssueDetailViewController.m
//  GitLabIssues
//
//  Created by Piet Brauer on 17.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import "NBNIssueDetailViewController.h"
#import "NBNIssueEditViewController.h"
#import "NBNIssuesConnection.h"
#import "NBNUsersConnection.h"
#import "NBNMilestoneConnection.h"
#import "NSString+NSHash.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"

#import "Issue.h"
#import "Assignee.h"
#import "Author.h"
#import "Milestone.h"
#import "DAKeyboardControl.h"

#import "NBNIssueDetailCell.h"
#import "NBNIssueDescriptionCell.h"
#import "NBNIssueCommentCell.h"

#import "NBNMilestonesListViewController.h"
#import "MBProgressHUD.h"
#import "NBNBackButtonHelper.h"


@interface NBNIssueDetailViewController ()

@property (nonatomic, retain) Issue *issue;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSString *commentString;
@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, retain) MBProgressHUD *HUD;

@end

@implementation NBNIssueDetailViewController

@synthesize issue;
@synthesize tableView;
@synthesize commentString;
@synthesize textField;
@synthesize HUD;

+(NBNIssueDetailViewController *)loadViewControllerWithIssue:(Issue *)_issue{
    NBNIssueDetailViewController *issueController = [[[NBNIssueDetailViewController alloc] init] autorelease];
    issueController.issue = _issue;
    issueController.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, issueController.view.frame.size.width, issueController.view.frame.size.height-42.f) style:UITableViewStylePlain]; //42.f is navbar image height
    issueController.tableView.delegate = issueController;
    issueController.tableView.dataSource = issueController;
    issueController.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [issueController.view addSubview:issueController.tableView];
    
    return issueController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f,
                                                                   0.0f,
                                                                   self.view.bounds.size.width,
                                                                   self.view.bounds.size.height - 42.0f-42.f)];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.title = [NSString stringWithFormat:@"Issue #%@", self.issue.identifier];
    [NBNBackButtonHelper setCustomBackButtonForViewController:self andNavigationItem:self.navigationItem];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setTitle:@"Edit" forState:UIControlStateNormal];
	[button.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.f]];
	[button setTitleColor:[UIColor colorWithWhite:1.f alpha:1.f] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, 58.f, 27.f)];
    [button addTarget:self action:@selector(editIssue) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"BarButtonPlain.png"] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setupKeyboard];
    [self refreshData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NBNIssuesConnection sharedConnection] cancelReloadConnection];
    [[NBNIssuesConnection sharedConnection] cancelNotesConnection];
}

-(void)refreshData{
    self.HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
    
	// Show the HUD while the provided method executes in a new thread
	[HUD show:YES];
    
    [[NBNIssuesConnection sharedConnection] reloadIssue:self.issue onSuccess:^{
        [self.tableView reloadData];
        [self.HUD setHidden:YES];
    }];
    
    [[NBNIssuesConnection sharedConnection] loadNotesForIssue:self.issue onSuccess:^(NSArray *notesArray) {
        [self.tableView reloadData];
        [self.HUD setHidden:YES];
    }];
}

-(void)setupKeyboard{
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f,
                                                                     self.view.bounds.size.height - 40.0f,
                                                                     self.view.bounds.size.width,
                                                                     40.0f)];
    toolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:toolBar];
    
    
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(10.0f,
                                                                   6.0f,
                                                                   toolBar.bounds.size.width - 20.0f - 68.0f,
                                                                   30.0f)];
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.textField.delegate = self;
    [self.textField addTarget:self action:@selector(updateBodyUsingContentsOfTextField:) forControlEvents:UIControlEventEditingChanged];
    [toolBar addSubview:self.textField];
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[sendButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.f]];
	[sendButton setTitleColor:[UIColor colorWithWhite:1.f alpha:1.f] forState:UIControlStateNormal];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"BarButtonPlain.png"] forState:UIControlStateNormal];
    
    sendButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [sendButton setTitle:@"Send" forState:UIControlStateNormal];
    sendButton.frame = CGRectMake(toolBar.bounds.size.width - 68.0f,
                                  6.0f,
                                  58.0f,
                                  29.0f);
    [sendButton addTarget:self action:@selector(sendPressed:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:sendButton];
    
    
    self.view.keyboardTriggerOffset = toolBar.bounds.size.height;
    
    [self.view addKeyboardPanningWithActionHandler:^(CGRect keyboardFrameInView) {
        /*
         Try not to call "self" inside this block (retain cycle).
         But if you do, make sure to remove DAKeyboardControl
         when you are done with the view controller by calling:
         [self.view removeKeyboardControl];
         */
        
        CGRect toolBarFrame = toolBar.frame;
        toolBarFrame.origin.y = keyboardFrameInView.origin.y - toolBarFrame.size.height;
        toolBar.frame = toolBarFrame;
        
        CGRect tableViewFrame = self.tableView.frame;
        tableViewFrame.size.height = toolBarFrame.origin.y;
        self.tableView.frame = tableViewFrame;
    }];
}

-(void)editIssue{
    NBNIssueEditViewController *editViewController = [NBNIssueEditViewController loadViewControllerWithIssue:self.issue];
    editViewController.editMode = YES;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:editViewController];
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:navController animated:YES completion:nil];
    
    [navController release];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5+self.issue.notes.allObjects.count;
}

-(UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *IssueDetailCellIdentifier = @"IssueDetailCellIdentifier";
    static NSString *IssueDescriptionCellIdentifier = @"IssueDescriptionCellIdentifier";
    static NSString *IssueCommentCellIdentifier = @"IssueCommentCellIdentifier";
    
    if (indexPath.row == 0) { //Assigned
        
        NBNIssueDetailCell *cell = [_tableView dequeueReusableCellWithIdentifier:IssueDetailCellIdentifier];
        if (!cell) {
            cell = [NBNIssueDetailCell loadCellFromNib];
        }
        
        cell.delegate = self;
        [cell configureCellWithHeadline:@"Assigned:" andDescription:self.issue.assignee.name];
        
        return cell;
        
    } else if (indexPath.row == 1){ // Status
        
        NBNIssueDetailCell *cell = [_tableView dequeueReusableCellWithIdentifier:IssueDetailCellIdentifier];
        if (!cell) {
            cell = [NBNIssueDetailCell loadCellFromNib];
        }
        
        cell.delegate = self;
        [cell configureCellWithHeadline:@"Status:" andDescription:[NSString stringWithFormat:@"%@", [self.issue.closed boolValue] ? @"Closed" : @"Open"]];
        
        return cell;
        
    } else if (indexPath.row == 2){ // Milestone
        
        NBNIssueDetailCell *cell = [_tableView dequeueReusableCellWithIdentifier:IssueDetailCellIdentifier];
        if (!cell) {
            cell = [NBNIssueDetailCell loadCellFromNib];
        }
        cell.delegate = self;
        [cell configureCellWithHeadline:@"Milestone:" andDescription:self.issue.milestone.title];
        
        return cell;
        
    } else if (indexPath.row == 3){ // Labels
        
        NBNIssueDetailCell *cell = [_tableView dequeueReusableCellWithIdentifier:IssueDetailCellIdentifier];
        if (!cell) {
            cell = [NBNIssueDetailCell loadCellFromNib];
        }
        
        [cell configureCellWithHeadline:@"Labels:" andDescription:self.issue.labels];
        
        return cell;
        
    } else if (indexPath.row == 4){ // Issue description
        
        NBNIssueDescriptionCell *cell = [_tableView dequeueReusableCellWithIdentifier:IssueDescriptionCellIdentifier];
        
        if (!cell) {
            cell = [NBNIssueDescriptionCell loadCellFromNib];
        }
        
        [cell configureCellWithIssue:self.issue];
        
        return cell;
        
    } else{
        
        NBNIssueCommentCell *cell = [_tableView dequeueReusableCellWithIdentifier:IssueCommentCellIdentifier];
        
        if (!cell) {
            cell = [NBNIssueCommentCell loadCellFromNib];
        }
        
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"created_at" ascending:YES];
        NSArray *descriptors = @[descriptor];
        Note *note = [[[self.issue.notes allObjects] sortedArrayUsingDescriptors:descriptors] objectAtIndex:indexPath.row-5];
        
        
        [cell configureCellWithNote:note];
        
        return cell;
        
    }
}

-(CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < 4) { // DetailCells e.g. assigned, status, milestone, labels
        return 44;
    } else if (indexPath.row == 4){ // description
        NBNIssueDescriptionCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"IssueDescriptionCellIdentifier"];
        
        if (!cell) {
            cell = [NBNIssueDescriptionCell loadCellFromNib];
        }
        
        return [cell getHeightForCellWithIssue:self.issue];
        
    } else if (indexPath.row > 4){ // notes
        NBNIssueCommentCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"IssueCommentCellIdentifier"];
        
        if (!cell) {
            cell = [NBNIssueCommentCell loadCellFromNib];
        }
        
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"created_at" ascending:YES];
        NSArray *descriptors = @[descriptor];
        Note *note = [[[self.issue.notes allObjects] sortedArrayUsingDescriptors:descriptors] objectAtIndex:indexPath.row-5];
        return [cell getHeightForCellWithNote:note];
    } else{
        return 44;
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)_textField{
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
}

- (void)updateBodyUsingContentsOfTextField:(id)sender {
    
    self.commentString = ((UITextField *)sender).text;
}

-(void)sendPressed:(id)sender{
    if ([self.commentString isEqualToString:@""]) { // abort crash with empty string
        return;
    }
    
    [[NBNIssuesConnection sharedConnection] sendNoteForIssue:self.issue andBody:self.commentString onSuccess:^{
        self.textField.text = @"";
        [self.view hideKeyboard];
        [self refreshData];
    }];
}

#pragma mark - NBNIssueDetailCellDelegate

-(void)cellWithLabel:(NSString *)label didSelectBubbleItem:(HEBubbleViewItem *)item{
    
    if ([label isEqualToString:@"Assigned:"]) {
        
        NBNAssigneeListViewController *list = [NBNAssigneeListViewController loadControllerWithProjectID:[self.issue.project_id integerValue]];
        list.delegate = self;
        
        [self.navigationController pushViewController:list animated:YES];
        
    } else if ([label isEqualToString:@"Status:"]){
        
        if ([self.issue.closed boolValue] == YES) {
            self.issue.closed = [NSNumber numberWithBool:NO];
        } else{
            self.issue.closed = [NSNumber numberWithBool:YES];
        }
        
        [self.issue saveChangesonSuccess:^{
            [self.tableView reloadData];
        }];
        
    } else if ([label isEqualToString:@"Milestone:"]){
        
        NBNMilestonesListViewController *list = [NBNMilestonesListViewController loadControllerWithProjectID:[self.issue.project_id integerValue]];
        list.delegate = self;
        [self.navigationController pushViewController:list animated:YES];
        
    } else if ([label isEqualToString:@"Labels:"]){
        
    }
}

-(void)didSelectMilestone:(Milestone *)selectedMilestone{
    self.issue.milestone = selectedMilestone;
    [self.issue saveChangesonSuccess:^{
        [self refreshData];
    }];
}

-(void)didSelectAssignee:(Assignee *)selectedAssignee{
    self.issue.assignee = selectedAssignee;
    [self.issue saveChangesonSuccess:^{
        [self refreshData];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc{
    self.issue = nil;
    self.tableView = nil;
    self.commentString = nil;
    self.textField = nil;
    self.HUD = nil;
    
    [issue release];
    [tableView release];
    [commentString release];
    [textField release];
    [HUD release];
    
    PBLog(@"deallocing %@", [self class]);
    [super dealloc];
}

@end
