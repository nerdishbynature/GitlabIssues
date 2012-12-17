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

extern NSString *const kKeyAssignedFilter;
extern NSString *const kKeyMilestoneFilter;
extern NSString *const kKeyLabelsFilter;
extern NSString *const kKeyIssueStatusFilter;
extern NSString *const kKeySortIssuesFilter;

@protocol NBNIssueFilterDelegate <NSObject>

-(void)applyFilter:(NSDictionary *)filterDictionary;

@end

@interface NBNIssueFilterViewController : UIViewController <NBNMilestoneListDelegate>

@property (nonatomic, assign) id<NBNIssueFilterDelegate> delegate;
@property (nonatomic, retain) Project *project;

@end
