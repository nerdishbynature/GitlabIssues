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

@property (nonatomic, strong) NSNumber * closed;
@property (nonatomic, strong) NSNumber * identifier;
@property (nonatomic, strong) NSNumber * merged;
@property (nonatomic, strong) NSNumber * project_id;
@property (nonatomic, strong) NSString * source_branch;
@property (nonatomic, strong) NSString * target_branch;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) Assignee *assignee;
@property (nonatomic, strong) Author *author;

@end
