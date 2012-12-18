//
//  NBNUsersConnection.h
//  GitLabIssues
//
//  Created by Piet Brauer on 18.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NBNUsersConnection : NSObject

+(NSArray *)loadMembersWithProjectID:(NSUInteger)project_id;

@end
