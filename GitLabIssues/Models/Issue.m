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
#import "Domain.h"
#import "Session.h"
#import "ASIHTTPRequest.h"


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

-(void)save{
    Domain *domain = [[Domain findAll] objectAtIndex:0];
    Session *session = [[Session findAll] objectAtIndex:0];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/api/v2/projects/%@/issues/%@?private_token=%@",domain.protocol, domain.domain, self.project_id , self.identifier, session.private_token]];
    PBLog(@"url %@", url);
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setRequestMethod:@"PUT"];
    
    [request appendPostData:[self toJSON]];
    [request startSynchronous];
    
    if (request.error) {
        PBLog(@"%@", request.error);
    }

}

-(NSData *)toJSON{
    NSDictionary *dict = @{ @"id" : self.project_id,
    @"issue_id": self.identifier,
    @"title": self.title,
    @"description": self.descriptionString,
    @"assignee_id": self.assignee.identifier,
    @"milestone_id": self.milestone.identifier,
    @"closed": self.closed };
    
    return [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil];
}

-(void)saveMilestone{
    Domain *domain = [[Domain findAll] objectAtIndex:0];
    Session *session = [[Session findAll] objectAtIndex:0];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/api/v2/projects/%@/milestones/%@?private_token=%@",domain.protocol, domain.domain, self.project_id , self.milestone.identifier, session.private_token]];
    PBLog(@"url %@", url);
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setRequestMethod:@"PUT"];
    
    [request appendPostData:[self milestoneToJSON]];
    [request startSynchronous];
    
    PBLog(@"%@", request.error);
    PBLog(@"%@", request.responseString);
}

-(NSData *)milestoneToJSON{
    NSDictionary *dict = @{
    @"id" : self.project_id,
    @"milestone_id": self.milestone.identifier,
    @"title": self.milestone.title,
    @"description": self.milestone.descriptionString,
    @"closed": self.milestone.closed };
    
    return [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil];
}

@end
