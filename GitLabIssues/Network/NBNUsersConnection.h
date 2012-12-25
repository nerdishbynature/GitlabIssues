//
//  NBNUsersConnection.h
//  GitLabIssues
//
//  Created by Piet Brauer on 18.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NBNUsersConnection : NSObject

/**
 @brief Loads all member for the specified project.
 @param projectID The gitlab project identifier
 @return Returns an array containing all parsed users.
 @see http://www.github.com/gitlabhq/gitlabhq/docs/api/
 */
+(NSArray *)loadMembersWithProjectID:(NSUInteger)project_id;

@end
