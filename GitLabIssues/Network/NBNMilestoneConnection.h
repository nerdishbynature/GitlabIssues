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
 @brief Loads all Milestones for the specified projects.
 @param projectID The gitlab project identifier
 @param block The completion Block which is called on success
 @see http://www.github.com/gitlabhq/gitlabhq/docs/api/
 */
+(void)loadAllMilestonesForProjectID:(NSUInteger)projectID onSuccess:(void (^)(void))block;

/**
 @brief Loads all Milestones for the specified projects.
 @param projectID The gitlab project identifier
 @return Returns an array containing all parsed milestones.
 @see http://www.github.com/gitlabhq/gitlabhq/docs/api/
 */
+(NSArray *)loadMilestonesWithProjectID:(NSUInteger)projectID;

@end
