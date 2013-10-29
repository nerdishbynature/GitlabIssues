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
#import "WBErrorNoticeView.h"


@interface NBNIssueDetailViewController ()

@property (nonatomic, strong) Issue *issue;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *commentString;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) MBProgressHUD *HUD;

@end

@implementation NBNIssueDetailViewController

@synthesize issue;
@synthesize tableView;
@synthesize commentString;
@synthesize textField;
@synthesize HUD;

+(NBNIssueDetailViewController *)loadViewControllerWithIssue:(Issue *)_issue{
    NBNIssueDetailViewController *issueController = [[NBNIssueDetailViewController alloc] init];
    issueController.issue = _issue;
    issueController.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, issueController.view.frame.size.width, issueController.view.frame.size.height-42.f-40.f) style:UITableViewStylePlain]; //42.f is navbar image height
    issueController.tableView.delegate = issueController;
    issueController.tableView.dataSource = issueController;
    issueController.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [issueController.view addSubview:issueController.tableView];
    
    return issueController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@ #%@", NSLocalizedString(@"Issue", nil), self.issue.identifier];
    [NBNBackButtonHelper setCustomBackButtonForViewController:self andNavigationItem:self.navigationItem];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setTitle:NSLocalizedString(@"Edit", nil) forState:UIControlStateNormal];
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
	[self.view addSubview:HUD];
    
	// Show the HUD while the provided method executes in a new thread
	[HUD show:YES];
    
    [[NBNIssuesConnection sharedConnection] reloadIssue:self.issue onSuccess:^{
        [self.tableView reloadData];
        [self.HUD setHidden:YES];
        [self.HUD removeFromSuperview];
    }];
    
    [[NBNIssuesConnection sharedConnection] loadNotesForIssue:self.issue onSuccess:^(NSArray *notesArray) {
        [self.tableView reloadData];
        [self.HUD setHidden:YES];
        [self.HUD removeFromSuperview];
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
    [sendButton setTitle:NSLocalizedString(@"Send", nil) forState:UIControlStateNormal];
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
        
//        CGRect toolBarFrame = toolBar.frame;
//        toolBarFrame.origin.y = keyboardFrameInView.origin.y - toolBarFrame.size.height;
//        toolBar.frame = toolBarFrame;
//        
//        CGRect tableViewFrame = blockSelf.tableView.frame;
//        tableViewFrame.size.height = toolBarFrame.origin.y;
//        self.tableView.frame = tableViewFrame;
//        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.tableView numberOfRowsInSection:0]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }];
}

-(void)editIssue{
    NBNIssueEditViewController *editViewController = [NBNIssueEditViewController loadViewControllerWithIssue:self.issue];
    editViewController.editMode = YES;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:editViewController];
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:navController animated:YES completion:nil];
    
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
        [cell configureCellWithHeadline:NSLocalizedString(@"Assigned:", nil) andDescription:self.issue.assignee.name];
        
        return cell;
        
    } else if (indexPath.row == 1){ // Status
        
        NBNIssueDetailCell *cell = [_tableView dequeueReusableCellWithIdentifier:IssueDetailCellIdentifier];
        if (!cell) {
            cell = [NBNIssueDetailCell loadCellFromNib];
        }
        
        cell.delegate = self;
        [cell configureCellWithHeadline:NSLocalizedString(@"Status:", nil) andDescription:[NSString stringWithFormat:@"%@", [self.issue.closed boolValue] ? NSLocalizedString(@"Closed", nil) : NSLocalizedString(@"Open", nil)]];
        
        return cell;
        
    } else if (indexPath.row == 2){ // Milestone
        
        NBNIssueDetailCell *cell = [_tableView dequeueReusableCellWithIdentifier:IssueDetailCellIdentifier];
        if (!cell) {
            cell = [NBNIssueDetailCell loadCellFromNib];
        }
        cell.delegate = self;
        [cell configureCellWithHeadline:NSLocalizedString(@"Milestone:", nil) andDescription:self.issue.milestone.title];
        
        return cell;
        
    } else if (indexPath.row == 3){ // Labels
        
        NBNIssueDetailCell *cell = [_tableView dequeueReusableCellWithIdentifier:IssueDetailCellIdentifier];
        if (!cell) {
            cell = [NBNIssueDetailCell loadCellFromNib];
        }
        
        [cell configureCellWithHeadline:NSLocalizedString(@"Labels:", nil) andDescription:self.issue.labels];
        
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
    if (!self.commentString) { // abort crash with empty string
        [self.view hideKeyboard];
        return;
    }
    
    [[NBNIssuesConnection sharedConnection] sendNoteForIssue:self.issue andBody:self.commentString onSuccess:^(BOOL success){
        self.textField.text = @"";
        [self.view hideKeyboard];
        
        if (success) {
            [self refreshData];
        } else{        
            WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:self.tableView
                                                                       title:NSLocalizedString(@"Error", nil)
                                                                     message:NSLocalizedString(@"An error occured while add your comment, please try again later.", nil)];
            
            notice.duration = 1.f;
            [notice setDismissalBlock:^(BOOL dismissedInteractively) {
                
            }];
            [notice show];
            
        }
        
     
    }];
}

#pragma mark - NBNIssueDetailCellDelegate

-(void)cellWithLabel:(NSString *)label didSelectBubbleItem:(HEBubbleViewItem *)item{
    
    if ([label isEqualToString:NSLocalizedString(@"Assigned:", nil)]) {
        
        NBNAssigneeListViewController *list = [NBNAssigneeListViewController loadControllerWithProjectID:[self.issue.project_id integerValue]];
        list.delegate = self;
        
        [self.navigationController pushViewController:list animated:YES];
        
    } else if ([label isEqualToString:NSLocalizedString(@"Status:", nil)]){
        
        if ([self.issue.closed isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            self.issue.closed = [NSNumber numberWithBool:NO];
        } else{
            self.issue.closed = [NSNumber numberWithBool:YES];
        }
        
        [self.issue saveChangesonSuccess:^(BOOL success){
            if (success) {
                [self refreshData];
            }
        }];
        
    } else if ([label isEqualToString:NSLocalizedString(@"Milestone:", nil)]){
        
        NBNMilestonesListViewController *list = [NBNMilestonesListViewController loadControllerWithProjectID:[self.issue.project_id integerValue]];
        list.delegate = self;
        [self.navigationController pushViewController:list animated:YES];
        
    } else if ([label isEqualToString:NSLocalizedString(@"Labels:", nil)]){
        
    }
}

-(void)didSelectMilestone:(Milestone *)selectedMilestone{
    self.issue.milestone = selectedMilestone;
    [self.issue saveChangesonSuccess:^(BOOL success){
        if (success) {
            [self refreshData];
        }
    }];
}

-(void)didSelectAssignee:(Assignee *)selectedAssignee{
    self.issue.assignee = selectedAssignee;
    [self.issue saveChangesonSuccess:^(BOOL success){
        if (success) {
            [self refreshData];
        }
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
    
    
    PBLog(@"deallocing %@", [self class]);
}

@end
