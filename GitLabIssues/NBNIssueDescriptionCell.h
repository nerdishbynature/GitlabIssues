//
//  NBNIssueDescriptionCell.h
//  GitLabIssues
//
//  Created by Piet Brauer on 31.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Issue.h"

@interface NBNIssueDescriptionCell : UITableViewCell

+(NBNIssueDescriptionCell *)loadCellFromNib;

-(void)configureCellWithIssue:(Issue *)issue;

-(CGFloat)getHeightForCellWithIssue:(Issue *)_issue;

@end
