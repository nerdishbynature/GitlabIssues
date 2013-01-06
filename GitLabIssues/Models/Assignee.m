//
//  Assignee.m
//  GitLabIssues
//
//  Created by Piet Brauer on 16.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import "Assignee.h"
#import "Issue.h"
#import "MergeRequest.h"


@implementation Assignee

@dynamic blocked;
@dynamic created_at;
@dynamic email;
@dynamic identifier;
@dynamic name;
@dynamic issues;
@dynamic mergeRequests;
@dynamic filter;

+(Assignee *)createAndParseJSON:(NSDictionary *)dict{
    Assignee *assignee = [Assignee createEntity];
    /*{
     
     "id": 1,
     "email": "john@example.com",
     "name": "John Smith",
     "blocked": false,
     "created_at": "2012-05-23T08:00:58Z",
     "access_level": 40
     }*/
    if ([(NSNull *)dict isMemberOfClass:[NSNull class]]) {
        return assignee;
    }
    assignee.identifier = [NSNumber numberWithInt:[[dict objectForKey:@"id"] integerValue]];
    assignee.email = [dict objectForKey:@"email"];
    assignee.name = [dict objectForKey:@"name"];
    assignee.blocked = [NSNumber numberWithBool:[[dict objectForKey:@"blocked"] boolValue]];
    
    return assignee;
}

@end
