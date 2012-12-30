//
//  NBNIssueCell.h
//  GitLabIssues
//
//  Created by Piet Brauer on 30.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Issue.h"

@interface NBNIssueCell : UITableViewCell

-(void)configureCellWithIssue:(Issue *)_issue;

+(NBNIssueCell *)loadCellFromNib;

-(CGFloat)getCalculatedHeight:(Issue *)_issue;

@end
