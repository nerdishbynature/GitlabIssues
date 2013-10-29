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
@dynamic project_id;
@dynamic filter;

+(Milestone *)createAndParseJSON:(NSDictionary *)dict andProjectID:(NSUInteger)projectID{
    Milestone *milestone = [Milestone MR_createEntity];
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
    milestone.project_id = [NSNumber numberWithInteger:projectID];
    
    return milestone;
}

-(void)parseServerResponseWithDict:(NSDictionary *)dict{
    self.title = [dict objectForKey:@"title"];
    self.descriptionString = [dict objectForKey:@"description"],
    self.closed = [NSNumber numberWithBool:[[dict objectForKey:@"closed"] boolValue]];
}

@end
