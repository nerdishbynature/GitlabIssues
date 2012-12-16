//
//  Milestone.m
//  GitLabIssues
//
//  Created by Piet Brauer on 16.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import "Milestone.h"
#import "Issue.h"


@implementation Milestone

@dynamic closed;
@dynamic created_at;
@dynamic descriptionString;
@dynamic due_date;
@dynamic identifier;
@dynamic title;
@dynamic issue;

+(Milestone *)createAndParseJSON:(NSDictionary *)dict{
    Milestone *milestone = [Milestone createEntity];
    /*
     "milestone": {
     "id": 1,
     "title": "v1.0",
     "description": "",
     "due_date": "2012-07-20",
     "closed": false,
     "updated_at": "2012-07-04T13:42:48Z",
     "created_at": "2012-07-04T13:42:48Z"
     }*/
    if ([(NSNull *)dict isMemberOfClass:[NSNull class]]) {
        return milestone;
    }
    milestone.identifier = [NSNumber numberWithInt:[[dict objectForKey:@"id"] integerValue]];
    milestone.title = [dict objectForKey:@"title"];
    milestone.descriptionString = [dict objectForKey:@"description"],
    milestone.closed = [NSNumber numberWithBool:[[dict objectForKey:@"closed"] boolValue]];
    
    return milestone;
}

@end