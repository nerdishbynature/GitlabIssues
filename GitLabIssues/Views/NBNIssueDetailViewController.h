//
//  NBNIssueDetailViewController.h
//  GitLabIssues
//
//  Created by Piet Brauer on 17.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Issue.h"

@interface NBNIssueDetailViewController : UIViewController

+(NBNIssueDetailViewController *)loadViewControllerWithIssue:(Issue *)_issue;

@end
