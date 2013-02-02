//
//  NBNDeletionHelper.m
//  GitLabIssues
//
//  Created by Piet Brauer on 02.02.13.
//  Copyright (c) 2013 nerdishbynature. All rights reserved.
//

#import "NBNDeletionHelper.h"
#import "Models.h"

@implementation NBNDeletionHelper

+(void)deletePersistedData{
    [Filter MR_truncateAll];
    [Owner MR_truncateAll];
    [Session MR_truncateAll];
    [SSH_key MR_truncateAll];
    [Note MR_truncateAll];
    [Project MR_truncateAll];
    [MergeRequest MR_truncateAll];
    [Snippet MR_truncateAll];
    [Domain MR_truncateAll];
    [User MR_truncateAll];
    [Issue MR_truncateAll];
    [Author MR_truncateAll];
    [Assignee MR_truncateAll];
    [Milestone MR_truncateAll];
}

@end
