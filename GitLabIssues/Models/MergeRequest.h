//
//  MergeRequest.h
//  GitLabIssues
//
//  Created by Piet Brauer on 16.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Assignee, Author;

@interface MergeRequest : NSManagedObject

@property (nonatomic, retain) NSNumber * closed;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSNumber * merged;
@property (nonatomic, retain) NSNumber * project_id;
@property (nonatomic, retain) NSString * source_branch;
@property (nonatomic, retain) NSString * target_branch;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Assignee *assignee;
@property (nonatomic, retain) Author *author;

@end
