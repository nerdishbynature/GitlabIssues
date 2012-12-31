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
#import "NSString+NSHash.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "Issue.h"
#import "Assignee.h"
#import "Author.h"
#import "Milestone.h"

#import "NBNIssueDetailCell.h"
#import "NBNIssueDescriptionCell.h"
#import "NBNIssueCommentCell.h"


@interface NBNIssueDetailViewController ()

@property (nonatomic, retain) Issue *issue;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UILabel *assignedLabel;
@property (nonatomic, retain) IBOutlet UILabel *assignedDescriptionLabel;
@property (nonatomic, retain) IBOutlet UILabel *statusLabel;
@property (nonatomic, retain) IBOutlet UILabel *statusDescriptionLabel;
@property (nonatomic, retain) IBOutlet UIImageView *authorImage;
@property (nonatomic, retain) IBOutlet UILabel *authorNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *issueHeaderLabel;
@property (nonatomic, retain) IBOutlet UILabel *descriptionLabel;

@end

@implementation NBNIssueDetailViewController

@synthesize issue;
@synthesize scrollView;
@synthesize assignedLabel;
@synthesize assignedDescriptionLabel;
@synthesize statusLabel;
@synthesize statusDescriptionLabel;
@synthesize authorImage;
@synthesize authorNameLabel;
@synthesize issueHeaderLabel;
@synthesize descriptionLabel;


+(NBNIssueDetailViewController *)loadViewControllerWithIssue:(Issue *)_issue{
    NBNIssueDetailViewController *issueController = [[[NBNIssueDetailViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
    issueController.issue = _issue;
    
    return issueController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.toolbarHidden = YES;
    self.title = [NSString stringWithFormat:@"Issue #%@", self.issue.identifier];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editIssue)];
    [NBNIssuesConnection loadNotesForIssue:self.issue onSuccess:^(NSArray *notesArray) {
        self.issue.notes = [NSSet setWithArray:notesArray];
        [self.tableView reloadData];
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *IssueDetailCellIdentifier = @"IssueDetailCellIdentifier";
    static NSString *IssueDescriptionCellIdentifier = @"IssueDescriptionCellIdentifier";
    static NSString *IssueCommentCellIdentifier = @"IssueCommentCellIdentifier";
    
    if (indexPath.row == 0) { //Assigned
        
        NBNIssueDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:IssueDetailCellIdentifier];
        if (!cell) {
            cell = [NBNIssueDetailCell loadCellFromNib];
        }
        
        [cell configureCellWithHeadline:@"Assigned:" andDescription:self.issue.assignee.name];
        
        return cell;
        
    } else if (indexPath.row == 1){ // Status
        
        NBNIssueDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:IssueDetailCellIdentifier];
        if (!cell) {
            cell = [NBNIssueDetailCell loadCellFromNib];
        }
        
        [cell configureCellWithHeadline:@"Status:" andDescription:[NSString stringWithFormat:@"%@", self.issue.closed ? @"Closed" : @"Open"]];
        
        return cell;
        
    } else if (indexPath.row == 2){ // Milestone
    
        NBNIssueDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:IssueDetailCellIdentifier];
        if (!cell) {
            cell = [NBNIssueDetailCell loadCellFromNib];
        }
        
        [cell configureCellWithHeadline:@"Milestone:" andDescription:self.issue.milestone.title];
    
        return cell;
        
    } else if (indexPath.row == 3){ // Labels
        
        NBNIssueDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:IssueDetailCellIdentifier];
        if (!cell) {
            cell = [NBNIssueDetailCell loadCellFromNib];
        }
        
        [cell configureCellWithHeadline:@"Labels:" andDescription:@"need to implement"];
        
        return cell;
        
    } else if (indexPath.row == 4){ // Issue description
        
        NBNIssueDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:IssueDescriptionCellIdentifier];
        
        if (!cell) {
            cell = [NBNIssueDescriptionCell loadCellFromNib];
        }
        
        [cell configureCellWithIssue:self.issue];
        
        return cell;
        
    } else{
    
        NBNIssueCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:IssueCommentCellIdentifier];
        
        if (!cell) {
            cell = [NBNIssueCommentCell loadCellFromNib];
        }
        
        Note *note = [[self.issue.notes allObjects] objectAtIndex:indexPath.row-5];
        
        [cell configureCellWithNote:note];
        
        return cell;
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < 4) { // DetailCells e.g. assigned, status, milestone, labels
        return 44;
    } else if (indexPath.row == 4){ // description
        NBNIssueDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IssueDescriptionCellIdentifier"];
        
        if (!cell) {
            cell = [NBNIssueDescriptionCell loadCellFromNib];
        }
        
        return [cell getHeightForCellWithIssue:self.issue];
        
    } else if (indexPath.row > 4){ // notes
        NBNIssueCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IssueCommentCellIdentifier"];
        
        if (!cell) {
            cell = [NBNIssueCommentCell loadCellFromNib];
        }
        
        Note *note = [[self.issue.notes allObjects] objectAtIndex:indexPath.row-5];
        return [cell getHeightForCellWithNote:note];
    } else{
        return 44;
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    self.issue = nil;
    self.scrollView = nil;
    self.assignedLabel = nil;
    self.assignedDescriptionLabel = nil;
    self.statusLabel = nil;
    self.statusDescriptionLabel = nil;
    self.authorImage = nil;
    self.authorNameLabel = nil;
    self.issueHeaderLabel = nil;
    self.descriptionLabel = nil;
    
    [issue release];
    [scrollView release];
    [assignedLabel release];
    [assignedDescriptionLabel release];
    [statusLabel release];
    [statusDescriptionLabel release];
    [authorImage release];
    [authorNameLabel release];
    [issueHeaderLabel release];
    [descriptionLabel release];
    
    [super dealloc];
}

@end
