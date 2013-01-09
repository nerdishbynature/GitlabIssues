//
//  NBNMilestoneConnection.h
//  GitLabIssues
//
//  Created by Piet Brauer on 17.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NBNMilestoneConnection : NSObject

/**
  Loads all Milestones for the specified project.
 @param projectID The gitlab project identifier
 @param block The completion Block which is called on success
 @see https://github.com/gitlabhq/gitlabhq/blob/master/doc/api/milestones.md#list-project-milestones
 */
+(void)loadAllMilestonesForProjectID:(NSUInteger)projectID onSuccess:(void (^)(void))block;

/**
  Loads all Milestones for the specified project.
 @param projectID The gitlab project identifier
 @return Returns an array containing all parsed milestones.
 @see https://github.com/gitlabhq/gitlabhq/blob/master/doc/api/milestones.md#list-project-milestones
 */
+(NSArray *)loadMilestonesWithProjectID:(NSUInteger)projectID;

@end
