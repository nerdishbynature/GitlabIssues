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
  Creates ViewController with associated issue and returns it
 @return NBNIssueEditViewController instance
 */
+(NBNIssueEditViewController *)loadViewControllerWithIssue:(Issue *)_issue;

/**
  editMode specifies if the associated issue is a new one (editMode == NO) or
 if the issue needs to be created on the server (POST method) or updated (PUT method)
 */
@property (nonatomic, assign) BOOL editMode;

@end
