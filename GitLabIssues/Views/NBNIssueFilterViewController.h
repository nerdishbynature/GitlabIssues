//
//  NBNIssueFilterViewController.h
//  GitLabIssues
//
//  Created by Piet Brauer on 17.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NBNIssueFilterDelegate <NSObject>

-(void)applyFilter:(NSDictionary *)filterDictionary;

@end

@interface NBNIssueFilterViewController : UIViewController

@property (nonatomic, assign) id<NBNIssueFilterDelegate> delegate;

@end
