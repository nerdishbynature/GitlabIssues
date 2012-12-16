//
//  MergeRequest.m
//  GitLabIssues
//
//  Created by Piet Brauer on 16.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import "MergeRequest.h"
#import "Assignee.h"
#import "Author.h"


@implementation MergeRequest

@dynamic closed;
@dynamic identifier;
@dynamic merged;
@dynamic project_id;
@dynamic source_branch;
@dynamic target_branch;
@dynamic title;
@dynamic assignee;
@dynamic author;

@end
