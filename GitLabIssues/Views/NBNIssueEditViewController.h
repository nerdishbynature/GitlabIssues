//
//  NBNIssueEditViewController.h
//  GitLabIssues
//
//  Created by Piet Brauer on 18.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Issue.h"

@interface NBNIssueEditViewController : UITableViewController <UIAlertViewDelegate>

/**
 @brief Creates ViewController with associated issue and returns it
 @return NBNIssueEditViewController instance
 */
+(NBNIssueEditViewController *)loadViewControllerWithIssue:(Issue *)_issue;

@property (nonatomic, assign) BOOL editMode;

@end
