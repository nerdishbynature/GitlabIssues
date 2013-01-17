//
//  NBNFilterComponentsCell.h
//  GitLabIssues
//
//  Created by Piet Brauer on 07.01.13.
//  Copyright (c) 2013 nerdishbynature. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Assignee.h"
#import "Milestone.h"
#import "HEBubbleView.h"
#import "HEBubbleViewItem.h"

@protocol NBNFilterComponentsCellDelegate <NSObject>

-(void)clearMilestone;

@end

@interface NBNFilterComponentsCell : UITableViewCell <HEBubbleViewDataSource, HEBubbleViewDelegate>

@property (nonatomic, assign) id<NBNFilterComponentsCellDelegate> delegate;

+(NBNFilterComponentsCell *)loadCellFromNib;

-(void)configureCellWithMilestone:(Milestone *)_milestone;

-(void)configureCellWithLabels:(NSArray *)_labels;

-(IBAction)clearButtonPushed:(id)sender;

@end
