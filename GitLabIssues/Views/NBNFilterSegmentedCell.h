//
//  NBNFilterSegmentedCell.h
//  GitLabIssues
//
//  Created by Piet Brauer on 07.01.13.
//  Copyright (c) 2013 nerdishbynature. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NBNFilterSegmentedCell : UITableViewCell

+(NBNFilterSegmentedCell *)loadCellFromNib;

-(void)configureCellIsClosedCell:(BOOL)_isClosedCell;

@end
