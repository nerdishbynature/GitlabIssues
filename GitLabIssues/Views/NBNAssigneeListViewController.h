//
//  NBNAssigneeListViewController.h
//  GitLabIssues
//
//  Created by Piet Brauer on 12.01.13.
//  Copyright (c) 2013 nerdishbynature. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Assignee.h"

@protocol NBNAssigneeListDelegate <NSObject>

/**
 Called, when a assignee is selected. This delegate method is implemented in NBNIssueFilterViewController
 to get additional filter options.
 @param selectedAssignee The assignee object which is selected
 */
-(void)didSelectAssignee:(Assignee *)selectedAssignee;

@end

@interface NBNAssigneeListViewController : UITableViewController <UISearchDisplayDelegate>

/**
 Called, when a milestone is selected. This delegate method is implemented in NBNIssueFilterViewController
 to get additional filter options.
 */
@property (nonatomic, assign) id<NBNAssigneeListDelegate> delegate;

/**
 Method sets up the view controller and returns the allocated and initialized object.
 This method is an shortcut to create the view controller and don't forget to set anything.
 @param _projectID The gitlab project identifier used to initialize the view controller.
 @return Returns an allocated and initialized view controller object.
 */
+(NBNAssigneeListViewController *)loadControllerWithProjectID:(NSUInteger)_projectID;

@end
