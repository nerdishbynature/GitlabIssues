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

-(void)didSelectMilestone:(Milestone *)selectedMilestone;

@end

@interface NBNMilestonesListViewController : UITableViewController <UISearchDisplayDelegate>

@property (nonatomic, assign) id<NBNMilestoneListDelegate> delegate;

+(NBNMilestonesListViewController *)loadControllerWithProjectID:(NSUInteger)_projectID;

@end
