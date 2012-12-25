//
//  NBNIssuesConnection.h
//  GitLabIssues
//
//  Created by Piet Brauer on 16.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Project.h"

@interface NBNIssuesConnection : NSObject

/**
 @brief Loads all issues for the specified project.
 @param project The project object
 @param block The completion Block which is called on success
 @see https://github.com/gitlabhq/gitlabhq/blob/master/doc/api/issues.md#list-project-issues
 */
+(void)loadIssuesForProject:(Project *)project onSuccess:(void (^)(void))block;

@end
