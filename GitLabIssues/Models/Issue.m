//
//  Issue.m
//  GitLabIssues
//
//  Created by Piet Brauer on 16.12.12.
//  Copyright (c) 2012 nerdishbynature. All rights reserved.
//

#import "Issue.h"
#import "Assignee.h"
#import "Author.h"
#import "Milestone.h"


@implementation Issue

@dynamic closed;
@dynamic created_at;
@dynamic descriptionString;
@dynamic identifier;
@dynamic labels;
@dynamic project_id;
@dynamic title;
@dynamic updated_at;
@dynamic assignee;
@dynamic author;
@dynamic milestone;

+(Issue *)createAndParseJSON:(NSDictionary *)dict{
    Issue *issue = [Issue createEntity];
    /*{
     "id": 42,
     "project_id": 8,
     "title": "Add user settings",
     "description": "",
     "labels": [
     "feature"
     ],
     "milestone": {
     "id": 1,
     "title": "v1.0",
     "description": "",
     "due_date": "2012-07-20",
     "closed": false,
     "updated_at": "2012-07-04T13:42:48Z",
     "created_at": "2012-07-04T13:42:48Z"
     },
     "assignee": {
     "id": 2,
     "email": "jack@example.com",
     "name": "Jack Smith",
     "blocked": false,
     "created_at": "2012-05-23T08:01:01Z"
     },
     "author": {
     "id": 1,
     "email": "john@example.com",
     "name": "John Smith",
     "blocked": false,
     "created_at": "2012-05-23T08:00:58Z"
     },
     "closed": false,
     "updated_at": "2012-07-12T13:43:19Z",
     "created_at": "2012-06-28T12:58:06Z"
     }*/
    
    issue.identifier = [NSNumber numberWithInt:[[dict objectForKey:@"id"] integerValue]];
    issue.project_id = [NSNumber numberWithInt:[[dict objectForKey:@"project_id"] integerValue]];
    issue.title = [dict objectForKey:@"title"];
    
    int closedInt = [[dict valueForKey:@"closed"] integerValue];
    issue.closed = [NSNumber numberWithInt:closedInt];
    
    if (![[dict objectForKey:@"description"] isMemberOfClass:[NSNull class]]) {
        issue.descriptionString = [dict objectForKey:@"description"];
    }
    
    if ([dict objectForKey:@"assignee"]) {
        issue.assignee = [Assignee createAndParseJSON:[dict objectForKey:@"assignee"]];
    }
    
    if ([dict objectForKey:@"milestone"]) {
        issue.milestone = [Milestone createAndParseJSON:[dict objectForKey:@"milestone"] andProjectID:[issue.project_id integerValue]];
    }
    
    if ([dict objectForKey:@"author"]) {
        issue.author = [Author createAndParseJSON:[dict objectForKey:@"author"]];
    }
    
    return issue;
}

@end
