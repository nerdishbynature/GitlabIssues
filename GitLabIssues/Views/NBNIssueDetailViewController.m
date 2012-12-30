//
//  NBNIssueDetailViewController.m
//  GitLabIssues
//
//  Created by Piet Brauer on 17.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import "NBNIssueDetailViewController.h"
#import "NBNIssueEditViewController.h"
#import "NSString+NSHash.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "Issue.h"
#import "Assignee.h"
#import "Author.h"


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
    NBNIssueDetailViewController *issueController = [[NBNIssueDetailViewController alloc] initWithNibName:@"NBNIssueDetailViewController" bundle:nil];
    issueController.issue = _issue;
    
    return issueController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.toolbarHidden = YES;
    self.title = [NSString stringWithFormat:@"Issue #%@", self.issue.identifier];
    
    // Do any additional setup after loading the view from its nib.
    self.assignedLabel.text = @"Assigned:";
    self.assignedDescriptionLabel.text = self.issue.assignee.name;
    
    self.statusLabel.text = @"Status";
    self.statusDescriptionLabel.text = [self.issue.closed isEqualToNumber:[NSNumber numberWithBool:YES]] ? @"Open" : @"Closed";
    
    [self loadAuthorImage];
    
    self.authorNameLabel.text = self.issue.author.name;
    self.issueHeaderLabel.text = self.issue.title;
    self.descriptionLabel.text = self.issue.descriptionString;
    
    CGSize expectedSize = [self.descriptionLabel.text sizeWithFont:self.descriptionLabel.font constrainedToSize:CGSizeMake(self.descriptionLabel.frame.size.width, MAXFLOAT)];
    self.descriptionLabel.frame = CGRectMake(self.descriptionLabel.frame.origin.x, self.descriptionLabel.frame.origin.y, self.descriptionLabel.frame.size.width, expectedSize.height);
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.descriptionLabel.frame.origin.y + expectedSize.height);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editIssue)];
}

-(void)editIssue{
    NBNIssueEditViewController *editViewController = [NBNIssueEditViewController loadViewControllerWithIssue:self.issue];
    editViewController.editMode = YES;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:editViewController];
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;

    [self presentViewController:navController animated:YES completion:nil];
    
    [editViewController release];
    [navController release];
}

-(void)loadAuthorImage{
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.gravatar.com/avatar/%@?s=44", [self.issue.author.email MD5]]]];

    [request setCompletionBlock:^{
        self.authorImage.image = [UIImage imageWithData:request.responseData];
    }];
    
    [request setFailedBlock:^{
        PBLog(@"%@", [request.error localizedDescription]);
    }];
    
    [request startAsynchronous];
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
