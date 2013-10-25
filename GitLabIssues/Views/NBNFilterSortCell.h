//
//  NBNFilterSortCell.h
//  GitLabIssues
//
//  Created by Piet Brauer on 12.01.13.
//  Copyright (c) 2013 nerdishbynature. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NBNFilterSortCellDelegate <NSObject>

-(void)didChangeSortingTo:(BOOL)created;

@end

@interface NBNFilterSortCell : UITableViewCell

@property (nonatomic, weak) id<NBNFilterSortCellDelegate> delegate;
@property (nonatomic, assign) BOOL created;

-(void)configureView;

@end
