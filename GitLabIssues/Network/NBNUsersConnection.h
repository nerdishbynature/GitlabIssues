//
//  NBNUsersConnection.h
//  GitLabIssues
//
//  Created by Piet Brauer on 18.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NBNUsersConnection : NSObject

+ (NBNUsersConnection *) sharedConnection;

/**
  Loads all member for the specified project.
 @param projectID The gitlab project identifier
 @return Returns an array containing all parsed users.
 @see https://github.com/gitlabhq/gitlabhq/blob/master/doc/api/users.md#list-users
 */
-(NSArray *)loadMembersWithProjectID:(NSUInteger)project_id;

- (void) cancelMembersRequest;

@end
