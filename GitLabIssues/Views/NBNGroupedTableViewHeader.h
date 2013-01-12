//
//  NBNGroupedTableViewHeader.h
//  GitLabIssues
//
//  Created by Piet Brauer on 12.01.13.
//  Copyright (c) 2013 nerdishbynature. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NBNGroupedTableViewHeader : UIView

+(NBNGroupedTableViewHeader *)loadViewFromNib;

-(void)configureWithTitle:(NSString *)title;

@end
