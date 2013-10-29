//
//  NBNFilterStatusCell.h
//  GitLabIssues
//
//  Created by Piet Brauer on 12.01.13.
//  Copyright (c) 2013 nerdishbynature. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NBNFilterStatusCellDelegate <NSObject>

-(void)didChangeStatusTo:(BOOL)closed;

@end

@interface NBNFilterStatusCell : UITableViewCell

@property (nonatomic, weak) id<NBNFilterStatusCellDelegate> delegate;
@property (nonatomic, assign) BOOL closed;

-(void)configureView;

@end
