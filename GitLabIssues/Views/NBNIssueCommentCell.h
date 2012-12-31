//
//  NBNIssueCommentCell.h
//  GitLabIssues
//
//  Created by Piet Brauer on 31.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"

@interface NBNIssueCommentCell : UITableViewCell

+(NBNIssueCommentCell *)loadCellFromNib;

-(void)configureCellWithNote:(Note *)note;

-(CGFloat)getHeightForCellWithNote:(Note *)_note;

@end
