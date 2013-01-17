//
//  NBNFilterAssigneeCell.h
//  GitLabIssues
//
//  Created by Piet Brauer on 17.01.13.
//  Copyright (c) 2013 nerdishbynature. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Assignee.h"
#import "HEBubbleView.h"
#import "HEBubbleViewItem.h"

@protocol NBNFilterAssigneeCellDelegate <NSObject>

-(void)clearAssignee;

@end

@interface NBNFilterAssigneeCell : UITableViewCell <HEBubbleViewDataSource, HEBubbleViewDelegate>

@property (nonatomic, assign) id<NBNFilterAssigneeCellDelegate> delegate;

+(NBNFilterAssigneeCell *)loadCellFromNib;

-(void)configureCellWithAssignee:(Assignee *)_assignee;

-(IBAction)clearButtonPushed:(id)sender;

@end
