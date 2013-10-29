//
//  Filter.m
//  GitLabIssues
//
//  Created by Piet Brauer on 01.01.13.
//  Copyright (c) 2013 nerdishbynature. All rights reserved.
//

#import "Filter.h"
#import "Assignee.h"
#import "Milestone.h"


@implementation Filter

@dynamic labels;
@dynamic closed;
@dynamic sortCreated;
@dynamic assigned;
@dynamic milestone;
@dynamic project;

+(Filter *)loadDefaultFilter{
    Filter *filter = [Filter MR_createEntity];
    filter.closed = [NSNumber numberWithBool:NO];
    filter.sortCreated = [NSNumber numberWithBool:YES];
    filter.labels = @[];
    filter.assigned = nil;
    filter.milestone = nil;
    
    return filter;
}

@end
