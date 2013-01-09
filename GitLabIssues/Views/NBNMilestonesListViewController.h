//
//  NBNMilestonesListViewController.h
//  GitLabIssues
//
//  Created by Piet Brauer on 17.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Milestone.h"

@protocol NBNMilestoneListDelegate <NSObject>

/**
  Called, when a milestone is selected. This delegate method is implemented in NBNIssueFilterViewController 
 to get additional filter options.
 @param selectedMilestone The milestone object which is selected
 */
-(void)didSelectMilestone:(Milestone *)selectedMilestone;

@end

@interface NBNMilestonesListViewController : UITableViewController <UISearchDisplayDelegate>

/**
  Called, when a milestone is selected. This delegate method is implemented in NBNIssueFilterViewController
 to get additional filter options.
 */
@property (nonatomic, assign) id<NBNMilestoneListDelegate> delegate;

/**
  Method sets up the view controller and returns the allocated and initialized object.
 This method is an shortcut to create the view controller and don't forget to set anything.
 @param _projectID The gitlab project identifier used to initialize the view controller.
 @return Returns an allocated and initialized view controller object.
 */
+(NBNMilestonesListViewController *)loadControllerWithProjectID:(NSUInteger)_projectID;

@end
