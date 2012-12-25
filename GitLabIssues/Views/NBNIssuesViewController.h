//
//  NBNIssuesViewController.h
//  GitLabIssues
//
//  Created by Piet Brauer on 16.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project.h"
#import "NBNIssueFilterViewController.h"

@interface NBNIssuesViewController : UITableViewController <UISearchDisplayDelegate, NBNIssueFilterDelegate>

/**
 @brief Method sets up the view controller and returns the allocated and initialized object.
 This method is an shortcut to create the view controller and don't forget to set anything.
 @param _projectID The gitlab project identifier used to initialize the view controller.
 @return Returns an allocated and initialized view controller object.
 */
+(NBNIssuesViewController *)loadWithProject:(Project *)project;

@end
