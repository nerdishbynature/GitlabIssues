//
//  NBNIssueFilterViewController.h
//  GitLabIssues
//
//  Created by Piet Brauer on 17.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBNMilestonesListViewController.h"
#import "Project.h"
#import "Filter.h"

extern NSString *const kKeyAssignedFilter;
extern NSString *const kKeyMilestoneFilter;
extern NSString *const kKeyLabelsFilter;
extern NSString *const kKeyIssueStatusFilter;
extern NSString *const kKeySortIssuesFilter;

@protocol NBNIssueFilterDelegate <NSObject>

/**
 @brief Used to tell the associated view controller which filter to apply
 @param filterDictionary is a dictionary containing the filter settings
 */
-(void)applyFilter:(Filter *)_filter;

@end

@interface NBNIssueFilterViewController : UITableViewController <NBNMilestoneListDelegate>

/**
 @brief Used to tell the associated view controller which filter to apply
 */
@property (nonatomic, assign) id<NBNIssueFilterDelegate> delegate;

/**
 @brief Project used fot this ViewController
 */
@property (nonatomic, retain) Project *project;

/**
 */
+(NBNIssueFilterViewController *)loadViewControllerWithFilter:(Filter *)_filter;

@end
