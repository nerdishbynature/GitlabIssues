//
//  NBNLabelsListViewController.h
//  GitLabIssues
//
//  Created by Piet Brauer on 17.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NBNLabelListDelegate <NSObject>

//-(void)didSelectLabel:(Label *)label;

@end

@interface NBNLabelsListViewController : UITableViewController <UISearchDisplayDelegate>

@property (nonatomic, assign) id<NBNLabelListDelegate> delegate;

@end
