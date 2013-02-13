//
//  NBNIssueDetailViewController.h
//  GitLabIssues
//
//  Created by Piet Brauer on 17.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Issue.h"
#import "NBNIssueDetailCell.h"
#import "NBNMilestonesListViewController.h"
#import "NBNAssigneeListViewController.h"

@interface NBNIssueDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, NBNIssueDetailCellDelegate, NBNMilestoneListDelegate, NBNAssigneeListDelegate>

/**
 Method sets up the view controller and returns the allocated and initialized object.
 This method is an shortcut to create the view controller and don't forget to set anything.
 @param _issue The issue object used to initialize the view controller.
 @return Returns an allocated and initialized view controller object.
 */
+(NBNIssueDetailViewController *)loadViewControllerWithIssue:(Issue *)_issue;

@end
