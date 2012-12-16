//
//  NBNIssuesViewController.h
//  GitLabIssues
//
//  Created by Piet Brauer on 16.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project.h"

@interface NBNIssuesViewController : UITableViewController <UISearchDisplayDelegate>

+(NBNIssuesViewController *)loadWithProject:(Project *)project;

@end
