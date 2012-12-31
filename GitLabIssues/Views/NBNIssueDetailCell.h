//
//  NBNIssueDetailCell.h
//  GitLabIssues
//
//  Created by Piet Brauer on 31.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HEBubbleView.h"
#import "HEBubbleViewItem.h"

@interface NBNIssueDetailCell : UITableViewCell <HEBubbleViewDataSource, HEBubbleViewDelegate>

+(NBNIssueDetailCell *)loadCellFromNib;

-(void)configureCellWithHeadline:(NSString *)headline andDescription:(NSString *)_descriptionString;

@end
